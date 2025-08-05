import Foundation
import FirebaseAuth

protocol LoginViewModeling: AnyObject {
    var delegate: LoginViewModelDelegate? { get set }
    func login(email: String, password: String)
    func register(email: String, password: String)
    func checkLockoutStatus()
}

protocol LoginViewModelDelegate: AnyObject {
    func didReceiveError(_ message: String)
    func didUpdateLockout(remainingSeconds: Int)
    func lockoutEnded()
    func didLoginSuccessfully()
    func didRegisterSuccessfully()
}

private enum LockoutKeys {
    static let failedAttempts = "loginFailedAttempts"
    static let lockoutUntil = "loginLockoutUntil"
}

final class LoginViewModel: LoginViewModeling {
    weak var delegate: LoginViewModelDelegate?

    private let checkerService: CheckerServiceProtocol
    private var lockoutTimer: Timer?
    private(set) var remainingLockoutSeconds: Int = 0

    init(checkerService: CheckerServiceProtocol = CheckerService()) {
        self.checkerService = checkerService
    }

    func login(email: String, password: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            delegate?.didReceiveError("Email и пароль обязательны.")
            return
        }
        guard isValidEmail(trimmedEmail) else {
            delegate?.didReceiveError("Неверный формат e-mail.")
            return
        }

        if isLockedOut() {
            return
        }

        checkerService.checkCredentials(email: trimmedEmail, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.clearLockout()
                self.delegate?.didLoginSuccessfully()
            case .failure(let error):
                if let err = error as NSError?, AuthErrorCode(rawValue: err.code) == .userNotFound {
                    self.delegate?.didReceiveError("Пользователь не найден. Зарегистрируйтесь.")
                } else if let err = error as NSError?, AuthErrorCode(rawValue: err.code) == .wrongPassword {
                    self.processFailedAttempt()
                    self.delegate?.didReceiveError("Неправильный пароль.")
                } else {
                    self.processFailedAttempt()
                    self.delegate?.didReceiveError(self.mapFirebaseError(error))
                }
            }
        }
    }

    func register(email: String, password: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            delegate?.didReceiveError("Email и пароль обязательны.")
            return
        }
        guard isValidEmail(trimmedEmail) else {
            delegate?.didReceiveError("Неверный формат e-mail.")
            return
        }

        if isLockedOut() {
            return
        }

        checkerService.signUp(email: trimmedEmail, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.clearLockout()
                self.delegate?.didRegisterSuccessfully()
            case .failure(let error):
                self.processFailedAttempt()
                self.delegate?.didReceiveError(self.mapFirebaseError(error))
            }
        }
    }

    func checkLockoutStatus() {
        if let lockoutUntil = UserDefaults.standard.object(forKey: LockoutKeys.lockoutUntil) as? Date {
            let remaining = Int(lockoutUntil.timeIntervalSinceNow)
            if remaining > 0 {
                startLockoutTimer(seconds: remaining)
            } else {
                clearLockout()
            }
        } else {
            clearLockout()
        }
    }

    // MARK: - Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        return predicate.evaluate(with: email)
    }

    private func isLockedOut() -> Bool {
        if let lockoutUntil = UserDefaults.standard.object(forKey: LockoutKeys.lockoutUntil) as? Date {
            let remaining = Int(lockoutUntil.timeIntervalSinceNow)
            if remaining > 0 {
                startLockoutTimer(seconds: remaining)
                delegate?.didReceiveError("Попытки закончились, ждите \(remaining) сек.")
                return true
            } else {
                clearLockout()
            }
        }
        return false
    }

    private func processFailedAttempt() {
        var attempts = UserDefaults.standard.integer(forKey: LockoutKeys.failedAttempts)
        attempts += 1
        UserDefaults.standard.set(attempts, forKey: LockoutKeys.failedAttempts)

        if attempts >= 3 {
            let lockoutUntil = Date().addingTimeInterval(30)
            UserDefaults.standard.set(lockoutUntil, forKey: LockoutKeys.lockoutUntil)
            startLockoutTimer(seconds: 30)
            delegate?.didReceiveError("Попытки закончились, ждите 30 сек.")
        }
    }

    private func startLockoutTimer(seconds: Int) {
        remainingLockoutSeconds = max(0, seconds)
        delegate?.didUpdateLockout(remainingSeconds: remainingLockoutSeconds)

        lockoutTimer?.invalidate()
        lockoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingLockoutSeconds = max(0, self.remainingLockoutSeconds - 1)
            if self.remainingLockoutSeconds > 0 {
                self.delegate?.didUpdateLockout(remainingSeconds: self.remainingLockoutSeconds)
            } else {
                timer.invalidate()
                self.clearLockout()
                self.delegate?.lockoutEnded()
            }
        }
    }

    private func clearLockout() {
        UserDefaults.standard.set(0, forKey: LockoutKeys.failedAttempts)
        UserDefaults.standard.removeObject(forKey: LockoutKeys.lockoutUntil)
        lockoutTimer?.invalidate()
    }

    private func mapFirebaseError(_ error: Error) -> String {
        if let err = error as NSError? {
            switch AuthErrorCode(rawValue: err.code) {
            case .invalidEmail:
                return "Неверный e-mail."
            case .emailAlreadyInUse:
                return "Электронная почта уже используется."
            case .weakPassword:
                return "Пароль слишком слабый."
            default:
                return error.localizedDescription
            }
        }
        return error.localizedDescription
    }
}

