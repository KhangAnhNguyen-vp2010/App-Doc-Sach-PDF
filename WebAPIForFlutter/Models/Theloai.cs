using System;
using System.Collections.Generic;

namespace WebAPIForFlutter.Models;

public partial class Theloai
{
    public string MaLoai { get; set; } = null!;

    public string? TenLoai { get; set; }

    public virtual ICollection<Sach> Saches { get; set; } = new List<Sach>();
}
