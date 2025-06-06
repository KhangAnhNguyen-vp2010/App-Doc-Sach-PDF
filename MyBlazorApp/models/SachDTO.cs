namespace MyBlazorApp.Models;
using System.ComponentModel.DataAnnotations;
public class SachDTO
{
    public string Id { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string CoverUrl { get; set; } = string.Empty;
    public string PdfUrl { get; set; } = string.Empty;
    public int PageCount { get; set; }
    public int PublicationYear { get; set; }
    public int ViewCount { get; set; }
    public int LikeCount { get; set; }
    public TheloaiDTO? Category { get; set; }
}



public class SachCreateDTO
{
    [Required(ErrorMessage = "Tiêu đề không được để trống.")]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Tác giả không được để trống.")]
    public string Author { get; set; } = string.Empty;

    [Required(ErrorMessage = "Mô tả không được để trống.")]
    public string Description { get; set; } = string.Empty;

    [Required(ErrorMessage = "URL ảnh bìa không được để trống.")]
    [Url(ErrorMessage = "Ảnh bìa phải là một URL hợp lệ.")]
    public string CoverUrl { get; set; } = string.Empty;

    [Required(ErrorMessage = "URL PDF không được để trống.")]
    [Url(ErrorMessage = "PDF phải là một URL hợp lệ.")]
    public string PdfUrl { get; set; } = string.Empty;

    [Range(1, int.MaxValue, ErrorMessage = "Số trang phải lớn hơn 0.")]
    public int PageCount { get; set; }

    [Range(1500, 2100, ErrorMessage = "Năm xuất bản không hợp lệ.")]
    public int PublicationYear { get; set; }

    [Required(ErrorMessage = "Vui lòng chọn thể loại.")]
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