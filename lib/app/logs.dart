// usage: logService.d  (debug)
// usage: logService.i  (info)
// usage: logService.w  (warning)
// usage: logService.e  (error)
// usage: logService.f  (fatal)
// (dynamic message, Object? error, StackTrace? stackTrace)

import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
// Conditional import skip path_provider if not web (path_provider 2.1.5 not support web yet)
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart'; // Conditional import

class FileLogOutput extends LogOutput {
  final String fileName;
  io.File? _logFile;
  io.IOSink? _sink;

  FileLogOutput({required this.fileName});

  @override
  Future<void> init() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      _logFile = io.File(filePath);
      _sink = _logFile!.openWrite(mode: io.FileMode.append);
    }
  }

  @override
  void output(OutputEvent event) {
    if (_sink != null) {
      // Only write to file if _sink is initialized (not web)
      for (var line in event.lines) {
        _sink?.writeln(line);
      }
    }
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _logFile = null; // Set _logFile to null after closing to prevent further use
  }
}

class LogService {
  static LogService? _instance;
  late final Logger _logger;
  final FileLogOutput? _fileOutput;

  // Private constructor (modified to accept optional FileLogOutput)
  LogService._internal(this._logger, [this._fileOutput]);

  // Static method to access the instance
  static Future<LogService> instance({String fileName = 'app_log.txt'}) async {
    if (_instance == null) {
      Logger logger;
      FileLogOutput? fileOutput;

      if (!kIsWeb) {
        fileOutput = FileLogOutput(fileName: fileName);
        await fileOutput.init();
        logger = Logger(
          printer: PrettyPrinter(),
          output: MultiOutput([ConsoleOutput(), fileOutput]),
        );
      } else {
        logger = Logger(printer: PrettyPrinter(), output: ConsoleOutput());
      }

      _instance = LogService._internal(logger, fileOutput);
    }
    return _instance!;
  }

  // Log methods
  void d(dynamic message, {Object? error, StackTrace? stackTrace}) {
    debugPrint(message);
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void i(dynamic message, {Object? error, StackTrace? stackTrace}) {
    debugPrint(message);
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, {Object? error, StackTrace? stackTrace}) {
    debugPrint(message);
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    debugPrint(message);
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void f(dynamic message, {Object? error, StackTrace? stackTrace}) {
    debugPrint(message);
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Close log file
  Future<void> close() async {
    await _fileOutput?.destroy();
    _instance = null;
  }
}
