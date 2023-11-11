import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();
  final todos = await dataSource.readAll();
  return Response.json(body: todos);
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();
  final json = await context.request.json();
  final todo = Todo.fromJson(json as Map<String, dynamic>);
  return Response.json(
    statusCode: HttpStatus.created,
    body: await dataSource.create(todo),
  );
}
