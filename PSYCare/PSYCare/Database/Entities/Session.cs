 using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PSYCare.Database.Entities
{
    public class Session
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int PatientId { get; set; }

        [Required]
        public int PsychologistId { get; set; }

        [Required]
        public DateTime ScheduledAt { get; set; }

        [Required]
        [MaxLength(20)]
        public string Status { get; set; } = "pending"; // pending, confirmed, cancelled

        [MaxLength(1000)]
        public string? Notes { get; set; }

        [ForeignKey(nameof(PatientId))]
        public virtual Patient? Patient { get; set; }

        [ForeignKey(nameof(PsychologistId))]
        public virtual Psychologist? Psychologist { get; set; }
    }
}