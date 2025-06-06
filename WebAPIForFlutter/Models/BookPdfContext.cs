using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace WebAPIForFlutter.Models;

public partial class BookPdfContext : DbContext
{
    public BookPdfContext()
    {
    }

    public BookPdfContext(DbContextOptions<BookPdfContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Sach> Saches { get; set; }

    public virtual DbSet<Theloai> Theloais { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=LAPTOP-8HLF4UKP\\SQLEXPRESS;Database=BOOK_PDF;Trusted_Connection=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Sach>(entity =>
        {
            entity.HasKey(e => e.MaSach);

            entity.ToTable("SACH");

            entity.Property(e => e.MaSach)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("MA_SACH");
            entity.Property(e => e.LinkAnhBia)
                .HasMaxLength(500)
                .HasColumnName("LINK_ANH_BIA");
            entity.Property(e => e.LuotLike)
                .HasDefaultValue(0)
                .HasColumnName("LUOT_LIKE");
            entity.Property(e => e.LuotXem)
                .HasDefaultValue(0)
                .HasColumnName("LUOT_XEM");
            entity.Property(e => e.MaLoai)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("MA_LOAI");
            entity.Property(e => e.MoTa)
                .HasMaxLength(1000)
                .HasColumnName("MO_TA");
            entity.Property(e => e.Namxuatban).HasColumnName("NAMXUATBAN");
            entity.Property(e => e.NgayDuaLen).HasColumnName("NGAY_DUA_LEN");
            entity.Property(e => e.Pdfurl)
                .HasMaxLength(500)
                .HasColumnName("PDFUrl");
            entity.Property(e => e.Sotrang).HasColumnName("SOTRANG");
            entity.Property(e => e.TacGia)
                .HasMaxLength(255)
                .HasColumnName("TAC_GIA");
            entity.Property(e => e.TenSach)
                .HasMaxLength(255)
                .HasColumnName("TEN_SACH");

            entity.HasOne(d => d.MaLoaiNavigation).WithMany(p => p.Saches)
                .HasForeignKey(d => d.MaLoai)
                .HasConstraintName("FK_SACH_THELOAI");
        });

        modelBuilder.Entity<Theloai>(entity =>
        {
            entity.HasKey(e => e.MaLoai);

            entity.ToTable("THELOAI");

            entity.Property(e => e.MaLoai)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("MA_LOAI");
            entity.Property(e => e.TenLoai)
                .HasMaxLength(255)
                .HasColumnName("TEN_LOAI");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
