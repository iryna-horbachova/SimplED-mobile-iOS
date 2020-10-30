enum APIError: String, Error {
  case invalidUsername = """
    You've entered invalid username.
    Please check it and try again.
  """
  case invalidData = """
    The data returned from the server was invalid.
    Please repeat your request.
  """
  case unableToComplete = """
    Unable to complete your request. Please check your internet connection"
  """
  case invalidResponse = """
    Invalid response from the server. Please try again.
  """
}
