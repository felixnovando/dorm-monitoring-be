import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ErrorCode, ErrorMessages } from './error-codes';
import { AppException } from './app.exception';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let code = ErrorCode.INTERNAL_ERROR;
    let message = ErrorMessages.INTERNAL_ERROR;

    // Custom AppException
    if (exception instanceof AppException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse() as any;

      code = exceptionResponse.code;
      message = exception.message;
    }
    // NestJS HttpException
    else if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse() as any;

      code = ErrorCode.VALIDATION_ERROR;
      message = typeof exceptionResponse === 'string' ? exceptionResponse : exceptionResponse.message || 'Request error';
    }
    // Unexpected error
    else {
     console.log('Unexpected error:', exception); 
    }

    response.status(status).json({
      success: false,
      code,
      message,
      path: request.url,
      timestamp: new Date().toISOString(),
    });
  }
}
