using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;
using WebAPIForFlutter.Models;
using WebAPIForFlutter.Repositories.Implementations;
using WebAPIForFlutter.Repositories.Interfaces;
using WebAPIForFlutter.Services.Implementations;
using WebAPIForFlutter.Services.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.WriteIndented = true;
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowBlazorApp",
        builder => builder
            .WithOrigins("http://localhost:5257")
            .AllowAnyMethod()
            .AllowAnyHeader());
});

// Add DbContext
builder.Services.AddDbContext<BookPdfContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register Repositories
builder.Services.AddScoped<ISachRepository, SachRepository>();
builder.Services.AddScoped<ITheloaiRepository, TheloaiRepository>();

// Register Services
builder.Services.AddScoped<ISachService, SachService>();
builder.Services.AddScoped<ITheloaiService, TheloaiService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();

// Use CORS
app.UseCors("AllowBlazorApp");

app.UseAuthorization();

app.MapControllers();

app.Run();
