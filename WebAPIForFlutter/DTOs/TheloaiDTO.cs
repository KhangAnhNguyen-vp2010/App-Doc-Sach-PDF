namespace WebAPIForFlutter.DTOs;

public class TheloaiDTO
{
    public string Id { get; set; } = null!;
    public string Name { get; set; } = null!;

    public Dictionary<string, object> ToJson()
    {
        return new Dictionary<string, object>
        {
            { "id", Id },
            { "name", Name }
        };
    }
}

public class TheloaiCreateDTO
{
    public string Id { get; set; } = null!;
    public string Name { get; set; } = null!;
}

public class TheloaiUpdateDTO
{
    public string Name { get; set; } = null!;
} 