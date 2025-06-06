using System;
using System.Collections.Generic;

namespace WebAPIForFlutter.Models;

public partial class Sach
{
    public string MaSach { get; set; } = null!;

    public string? TenSach { get; set; }

    public string? TacGia { get; set; }

    public string? MoTa { get; set; }

    public string? MaLoai { get; set; }

    public string? LinkAnhBia { get; set; }

    public string? Pdfurl { get; set; }

    public DateOnly? NgayDuaLen { get; set; }

    public int? Sotrang { get; set; }

    public int? Namxuatban { get; set; }

    public int? LuotXem { get; set; }

    public int? LuotLike { get; set; }

    public virtual Theloai? MaLoaiNavigation { get; set; }
}
