using System.ComponentModel.DataAnnotations;

namespace PSYCare.Database.Entities
{
    public class MoodEntry
    {
        public int Id { get; set; }

        public int PatientId { get; set; }

        [Range(1, 10)]
        public int Score { get; set; } // 1-10

        public string? Emoji { get; set; }
        public string? Notes { get; set; }
        public string? AudioUrl { get; set; }

        public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

        public Patient Patient { get; set; } = default!;
    }
}
