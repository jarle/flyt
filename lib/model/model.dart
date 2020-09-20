import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const library = SqfEntityTable(
  tableName: 'BookLibraryEntities',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
  ],
);

const bookReaders = SqfEntityTable(
  tableName: 'BookReaderEntities',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('cursorPosition', DbType.integer),
  ],
);

const books = SqfEntityTable(
  tableName: 'BookEntities',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('author', DbType.text),
    SqfEntityField('title', DbType.text),
    SqfEntityField('path', DbType.text),
    SqfEntityFieldRelationship(
        parentTable: bookReaders,
        deleteRule: DeleteRule.CASCADE,
        relationType: RelationType.ONE_TO_ONE),
  ],
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'BookLibraryModel',
  // optional
  databaseName: 'book_libraries.db',
  databaseTables: [library, bookReaders, books],
  sequences: [seqIdentity],
  bundledDatabasePath: null,
);
