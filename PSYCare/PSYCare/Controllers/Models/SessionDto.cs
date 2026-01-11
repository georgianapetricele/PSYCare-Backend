namespace PSYCare.Controllers.Models
{
    public class SessionCreateDto
    {
        public int PatientId { get; set; }
        public int PsychologistId { get; set; }
        public DateTime ScheduledAt { get; set; }
        public string? Notes { get; set; }
        public string Status { get; set; } = "pending";
    }

    public class SessionResponseDto
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public int PsychologistId { get; set; }
        public DateTime ScheduledAt { get; set; }
        public string? Status { get; set; }
        public string? Notes { get; set; }
    }
}
