//
//  LoginViewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import StorageService

protocol LoginViewModeling {
    var delegate: LoginViewModelDelegate? { get set }
    func login(_ login: String, _ password: String)
    func bruteForcePassword(length: Int, completion: @escaping (String) -> Void)
    
    func checkLockoutStatus()
}

private enum LoginLockoutKeys {
    static let failedAttempts = "loginFailedAttempts"
    static let lockoutUntil = "loginLockoutUntil"
}

import Foundation
import StorageService

final class LoginViewModel {
    private let userDefaultsService: UserDefaultsServicing
    private let userService: UserServicing
    private let testUserService: TestUserServicing
    
    weak var delegate: LoginViewModelDelegate?
    
    private var lockoutTimer: Timer?
    private(set) var remainingLockoutSeconds: Int = 0

    init(userDefaultsService: UserDefaultsServicing, userService: UserServicing) {
        self.userDefaultsService = userDefaultsService
        self.userService = userService
        self.testUserService = TestUserService()
    }
}

extension LoginViewModel: LoginViewModeling {

    func login(_ login: String, _ password: String) {
        do {
            let validatedLogin = try validateLogin(login)
            let validatedPassword = try validatePassword(password)

            let result: Result<User, Error>
            #if DEBUG
            result = testUserService.testAuth(login: validatedLogin, password: validatedPassword)
                .mapError { $0 as Error }
            #else
            result = userService.auth(login: validatedLogin, password: validatedPassword)
                .mapError { $0 as Error }
            #endif

            handleLogin(result: result)

        } catch {
            delegate?.didReceiveErrorMessage(error.localizedDescription)
        }
    }

    private func validateLogin(_ login: String?) throws -> String {
        guard let login = login, !login.isEmpty else {
            throw LoginError.emptyLogin
        }
        return login
    }

    private func validatePassword(_ password: String?) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw LoginError.emptyPassword
        }
        return password
    }

    private func handleLogin(result: Result<User, Error>) {
        switch result {
        case .success(let user):
            print("✅ Успешный вход: \(user.name)")
            userDefaultsService.setLoggedFlag(isLogIn: true)
        case .failure(let error):
            print("🚨 Ошибка входа: \(error.localizedDescription)")
            userDefaultsService.setLoggedFlag(isLogIn: false)
            processFailedAttempt()
            delegate?.didReceiveErrorMessage(error.localizedDescription)
        }
    }

    private func processFailedAttempt() {
        var attempts = UserDefaults.standard.integer(forKey: LoginLockoutKeys.failedAttempts)
        attempts += 1
        UserDefaults.standard.set(attempts, forKey: LoginLockoutKeys.failedAttempts)

        if attempts >= 3 {
            let lockoutUntil = Date().addingTimeInterval(30)
            UserDefaults.standard.set(lockoutUntil, forKey: LoginLockoutKeys.lockoutUntil)
            startLockoutTimer(seconds: 30)
        }
    }

    func checkLockoutStatus() {
        if let lockoutUntil = UserDefaults.standard.object(forKey: LoginLockoutKeys.lockoutUntil) as? Date {
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

    private func startLockoutTimer(seconds: Int) {
        remainingLockoutSeconds = seconds
        delegate?.didReceiveErrorMessage("Попытки закончились, ждите \(seconds) сек.")

        lockoutTimer?.invalidate()
        lockoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingLockoutSeconds -= 1
            if self.remainingLockoutSeconds > 0 {
                self.delegate?.didReceiveErrorMessage("Попытки закончились, ждите \(self.remainingLockoutSeconds) сек.")
            } else {
                timer.invalidate()
                self.clearLockout()
            }
        }
    }

    private func clearLockout() {
        UserDefaults.standard.set(0, forKey: LoginLockoutKeys.failedAttempts)
        UserDefaults.standard.removeObject(forKey: LoginLockoutKeys.lockoutUntil)
        delegate?.didReceiveErrorMessage(nil)
    }

    func bruteForcePassword(length: Int, completion: @escaping (String) -> Void) {
        let characters = String().printable
        let passwordToUnlock = String((0..<length).compactMap { _ in characters.randomElement() })
        let bruteForcer = PasswordBruteForcer()
        bruteForcer.bruteForce(passwordToUnlock: passwordToUnlock) { found in
            completion(found)
        }
    }
}
