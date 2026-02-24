export enum ErrorCode {
  // General
  INTERNAL_ERROR = 'INTERNAL_ERROR',
  VALIDATION_ERROR = 'VALIDATION_ERROR',

  // Auth
  UNAUTHORIZED = 'UNAUTHORIZED',
  FORBIDDEN = 'FORBIDDEN',
  INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
  TOKEN_EXPIRED = 'TOKEN_EXPIRED',

  // User
  USER_NOT_FOUND = 'USER_NOT_FOUND',
  EMAIL_ALREADY_EXISTS = 'EMAIL_ALREADY_EXISTS',

  // Resource
  RESOURCE_NOT_FOUND = 'RESOURCE_NOT_FOUND',

  // Business
  ITEM_OUT_OF_STOCK = 'ITEM_OUT_OF_STOCK',
};

export const ErrorMessages: Record<ErrorCode, string> = {
  INTERNAL_ERROR: 'Something went wrong',
  VALIDATION_ERROR: 'Invalid input data',

  UNAUTHORIZED: 'Unauthorized access',
  FORBIDDEN: 'Access denied',
  INVALID_CREDENTIALS: 'Invalid email or password',
  TOKEN_EXPIRED: 'Authentication token expired',

  USER_NOT_FOUND: 'User not found',
  EMAIL_ALREADY_EXISTS: 'Email is already registered',

  RESOURCE_NOT_FOUND: 'Requested resource not found',

  ITEM_OUT_OF_STOCK: 'Available quantity is not sufficient',
};