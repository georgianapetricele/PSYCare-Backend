namespace PSYCare.Controllers.Models
{
    public record MoodEntryCreateDto(int Score, string? Emoji, string? Notes, string? AudioUrl);
}
