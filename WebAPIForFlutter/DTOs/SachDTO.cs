namespace WebAPIForFlutter.DTOs;

public class SachDTO
{
    public string Id { get; set; } = null!;
    public string Title { get; set; } = null!;
    public string Author { get; set; } = null!;
    public string Description { get; set; } = null!;
    public string CoverUrl { get; set; } = null!;
    public string PdfUrl { get; set; } = null!;
    public DateTime UploadDate { get; set; }
    public int PageCount { get; set; }
    public int PublicationYear { get; set; }
    public int ViewCount { get; set; }
    public int LikeCount { get; set; }
    public TheloaiDTO? Category { get; set; }

    public Dictionary<string, object> ToJson()
    {
        return new Dictionary<string, object>
        {
            { "id", Id },
            { "title", Title },
            { "author", Author },
            { "description", Description },
            { "coverUrl", CoverUrl },
            { "pdfUrl", PdfUrl },
            { "uploadDate", UploadDate.ToString("o") },
            { "pageCount", PageCount },
            { "publicationYear", PublicationYear },
            { "viewCount", ViewCount },
            { "likeCount", LikeCount },
            { "category", Category?.ToJson() }
        };
    }
}

public class SachCreateDTO
{
    public string Title { get; set; } = null!;
    public string Author { get; set; } = null!;
    public string Description { get; set; } = null!;
    public string CoverUrl { get; set; } = null!;
    public string PdfUrl { get; set; } = null!;
    public int PageCount { get; set; }
    public int PublicationYear { get; set; }
    public string? CategoryId { get; set; }
}

public class SachUpdateDTO
{
    public string? Title { get; set; }
    public string? Author { get; set; }
    public string? Description { get; set; }
    public string? CoverUrl { get; set; }
    public string? PdfUrl { get; set; }
    public int? PageCount { get; set; }
    public int? PublicationYear { get; set; }
    public string? CategoryId { get; set; }
} 