namespace PSYCare.Controllers.Models
{
    public record MoodEntryResponseDto(int Id, int Score, string? Emoji, string? Notes, string? AudioUrl, DateTimeOffset CreatedAt);
}
