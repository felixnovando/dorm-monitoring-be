import { HttpException, HttpStatus } from '@nestjs/common';
import { ErrorCode, ErrorMessages } from './error-codes';

export class AppException extends HttpException {
  public readonly errorCode: ErrorCode;

  constructor(errorCode: ErrorCode, status: HttpStatus, customMessage?: string) {
    super(
      {
        code: errorCode,
        message: customMessage || ErrorMessages[errorCode],
      },
      status,
    );
    this.errorCode = errorCode;
  }
}
