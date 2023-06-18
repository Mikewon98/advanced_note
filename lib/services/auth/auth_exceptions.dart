//login Exception
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}
// register Exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic Exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedAuthException implements Exception {}
