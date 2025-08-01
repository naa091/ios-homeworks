import Foundation

enum LoginError: Error {
    case emptyLogin
    case emptyPassword
    case invalidCredentials
    case userNotFound
    case unknownError
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "Поле логина не должно быть пустым."
        case .emptyPassword:
            return "Поле пароля не должно быть пустым."
        case .invalidCredentials:
            return "Неверный логин или пароль."
        case .userNotFound:
            return "Пользователь не найден."
        case .unknownError:
            return "Произошла неизвестная ошибка."
        }
    }
}

