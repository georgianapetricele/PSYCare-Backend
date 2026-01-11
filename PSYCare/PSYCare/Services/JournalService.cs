using PSYCare.Controllers.Models;
using PSYCare.Database.Entities;
using PSYCare.Database;
using Microsoft.EntityFrameworkCore;

namespace PSYCare.Services
{
    public class JournalService : IJournalService
    {
        private readonly PSYCareDbContext _db;

        public JournalService(PSYCareDbContext db)
        {
            _db = db;
        }

        public async Task<JournalEntryResponseDto> CreateAsync(int patientId, JournalEntryCreateDto dto)
        {
            // Ensure patient exists (optional but nice)
            var patientExists = await _db.Patients.AnyAsync(p => p.Id == patientId);
            if (!patientExists)
                throw new KeyNotFoundException("Patient not found");

            var entity = new JournalEntry
            {
                PatientId = patientId,
                Text = Clean(dto.Text),
                CreatedAt = DateTimeOffset.UtcNow
            };

            _db.JournalEntries.Add(entity);
            await _db.SaveChangesAsync();

            return ToDto(entity);
        }

        public async Task<IReadOnlyList<JournalEntryResponseDto>> ListAsync(int patientId, int limit = 50)
        {
            limit = Math.Clamp(limit, 1, 200);

            return await _db.JournalEntries
                .Where(m => m.PatientId == patientId)
                .OrderByDescending(m => m.CreatedAt)
                .Take(limit)
                .Select(m => new JournalEntryResponseDto(m.Id, m.Text, m.CreatedAt))
                .ToListAsync();
        }

        public async Task UpdateAsync(int patientId, int entryId, JournalEntryCreateDto dto)
        {
            var entity = await _db.JournalEntries
                .FirstOrDefaultAsync(m => m.Id == entryId && m.PatientId == patientId);

            if (entity == null)
                throw new KeyNotFoundException("Mood entry not found");

            entity.Text = Clean(dto.Text);

            // Do NOT change CreatedAt
            await _db.SaveChangesAsync();
        }

        public async Task DeleteAsync(int patientId, int entryId)
        {
            var entity = await _db.JournalEntries
                .FirstOrDefaultAsync(m => m.Id == entryId && m.PatientId == patientId);

            if (entity == null)
                throw new KeyNotFoundException("Mood entry not found");

            _db.JournalEntries.Remove(entity);
            await _db.SaveChangesAsync();
        }

        private static JournalEntryResponseDto ToDto(JournalEntry m)
            => new(m.Id, m.Text , m.CreatedAt);

        private static string? Clean(string? s)
        {
            if (string.IsNullOrWhiteSpace(s)) return null;
            return s.Trim();
        }
    }
}
