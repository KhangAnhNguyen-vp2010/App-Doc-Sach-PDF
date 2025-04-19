class Document{
  String? doc_title;
  String? doc_url;
  String? doc_date;
  int? page_num;

  Document(this.doc_title, this.doc_url, this.doc_date, this.page_num);

  static List<Document> doc_list = [
    Document(
        "Test",
        "https://github.com/KhangAnhNguyen-vp2010/Kho-Luu-Tru-Sach-PDF/raw/fc65b5d43d2363b0b5ee57564ef34a69bf4401c4/AmThuc_NauAn/nhasachmienphi-206-mon-canh-dinh-duong-cho-tre-em.pdf",
        "29/03/2025",
        10),
    Document(
        "Test 2",
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        "29/03/2025",
        2)
  ];

}