// To parse this JSON data, do
//
//     final bookModel = bookModelFromJson(jsonString);

import 'dart:convert';

BookModel bookModelFromJson(String str) => BookModel.fromJson(json.decode(str));

String bookModelToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
  final int? bookId;
  final String? bookName;
  final String? bookAuthor;
  final String? bookContent;

  BookModel({
    this.bookId,
    this.bookName,
    this.bookAuthor,
    this.bookContent,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    bookId: json["book_id"],
    bookName: json["book_name"],
    bookAuthor: json["book_author"],
    bookContent: json["book_content"],
  );

  Map<String, dynamic> toJson() => {
    "book_name": bookName,
    "book_author": bookAuthor,
    "book_content": bookContent,
  };
}
