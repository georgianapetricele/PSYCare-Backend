namespace PSYCare.Controllers.Models
{
    public record JournalEntryResponseDto(int Id, string? Text, DateTimeOffset CreatedAt);
}
