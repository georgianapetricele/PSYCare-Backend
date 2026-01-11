using System.ComponentModel.DataAnnotations;

namespace PSYCare.Database.Entities
{
    public class JournalEntry
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public string? Text { get; set; }
        public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
        public Patient Patient { get; set; } = default!;
    }
}
