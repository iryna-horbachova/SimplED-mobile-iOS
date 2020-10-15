private struct Validator {
  static func isValid(password: String) -> Bool {
    guard password.count > 6, password.count < 20 else { return false }
    return true
  }

  static func isValid(email: String) -> Bool {
    let emailRegEx = ".+\\@.+\\..+"
    return email.range(of: emailRegEx, options: .regularExpression) != nil
  }
}
