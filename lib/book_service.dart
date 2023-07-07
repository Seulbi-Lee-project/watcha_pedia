import 'dart:convert';
import 'main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'book.dart';

class BookService extends ChangeNotifier {
  BookService() {
    loadBookList();
  }
  List<Book> bookList = []; // 책 목록
  List<Book> likedBookList = [];

  void toggleLikeBook({required Book book}) {
    String bookId = book.id;
    if (likedBookList.map((book) => book.id).contains(bookId)) {
      likedBookList.removeWhere((book) => book.id == bookId);
      saveLikeBook();
    } else {
      likedBookList.add(book);
      saveLikeBook();
    }
    notifyListeners();
  }

  void search(String q) async {
    bookList.clear(); // 검색 버튼 누를때 이전 데이터들을 지워주기

    if (q.isNotEmpty) {
      Response res = await Dio().get(
        "https://www.googleapis.com/books/v1/volumes?q=$q&startIndex=0&maxResults=40",
      );
      List items = res.data["items"];

      for (Map<String, dynamic> item in items) {
        Book book = Book(
          id: item['id'],
          title: item['volumeInfo']['title'] ?? "",
          subtitle: item['volumeInfo']['subtitle'] ?? "",
          authors: item['volumeInfo']['authors'] ?? List.empty(),
          publishedDate: item['volumeInfo']['publishedDate'] ?? "",
          thumbnail: item['volumeInfo']['imageLinks']?['thumbnail'] ??
              "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg",
          previewLink: item['volumeInfo']['previewLink'] ?? "",
        );
        bookList.add(book);
      }
    }
    notifyListeners();
  }

  saveLikeBook() {
    List likeBookJsonList = likedBookList.map((Book) => Book.toJson()).toList();
    String jsonString = jsonEncode(likeBookJsonList);
    prefs.setString('likedBookList', jsonString);
  }

  loadBookList() {
    String? jsonString = prefs.getString('likedBookList');
    if (jsonString == null) return; // null 이면 로드하지 않음
    List bookJsonList = jsonDecode(jsonString);
    likedBookList = bookJsonList.map((json) => Book.fromJson(json)).toList();
  }
}
