namespace MyBlazorApp.Models;
using System.ComponentModel.DataAnnotations;
public class TheloaiDTO
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
}

public class TheloaiCreateDTO
{
    [Required(ErrorMessage = "ID không được để trống")]
    [StringLength(10, ErrorMessage = "ID không quá 10 ký tự")]
    public string Id { get; set; } = null!;

    [Required(ErrorMessage = "Tên thể loại không được để trống")]
    [StringLength(100, ErrorMessage = "Tên thể loại không quá 100 ký tự")]
    public string Name { get; set; } = null!;
}

public class TheloaiUpdateDTO
{
    [Required(ErrorMessage = "Tên thể loại không được để trống")]
    [StringLength(100, ErrorMessage = "Tên thể loại không quá 100 ký tự")]
    public string Name { get; set; } = null!;
}