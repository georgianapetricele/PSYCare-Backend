using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services.Interfaces;

namespace PSYCare.Services
{
    public class MoodService : IMoodService
    {
        private readonly PSYCareDbContext _db;

        public MoodService(PSYCareDbContext db)
        {
            _db = db;
        }

        public async Task<MoodEntryResponseDto> CreateAsync(int patientId, MoodEntryCreateDto dto)
        {
            Validate(dto);

            // Ensure patient exists (optional but nice)
            var patientExists = await _db.Patients.AnyAsync(p => p.Id == patientId);
            if (!patientExists)
                throw new KeyNotFoundException("Patient not found");

            var entity = new MoodEntry
            {
                PatientId = patientId,
                Score = dto.Score,
                Emoji = Clean(dto.Emoji),
                Notes = Clean(dto.Notes),
                AudioUrl = Clean(dto.AudioUrl),
                CreatedAt = DateTimeOffset.UtcNow
            };

            _db.MoodEntries.Add(entity);
            await _db.SaveChangesAsync();

            return ToDto(entity);
        }

        public async Task<IReadOnlyList<MoodEntryResponseDto>> ListAsync(int patientId, int limit = 50)
        {
            limit = Math.Clamp(limit, 1, 200);

            return await _db.MoodEntries
                .Where(m => m.PatientId == patientId)
                .OrderByDescending(m => m.CreatedAt)
                .Take(limit)
                .Select(m => new MoodEntryResponseDto(m.Id, m.Score, m.Emoji, m.Notes, m.AudioUrl, m.CreatedAt))
                .ToListAsync();
        }

        public async Task UpdateAsync(int patientId, int moodId, MoodEntryCreateDto dto)
        {
            Validate(dto);

            var entity = await _db.MoodEntries
                .FirstOrDefaultAsync(m => m.Id == moodId && m.PatientId == patientId);

            if (entity == null)
                throw new KeyNotFoundException("Mood entry not found");

            entity.Score = dto.Score;
            entity.Emoji = Clean(dto.Emoji);
            entity.Notes = Clean(dto.Notes);
            entity.AudioUrl = Clean(dto.AudioUrl);

            // Do NOT change CreatedAt
            await _db.SaveChangesAsync();
        }

        public async Task DeleteAsync(int patientId, int moodId)
        {
            var entity = await _db.MoodEntries
                .FirstOrDefaultAsync(m => m.Id == moodId && m.PatientId == patientId);

            if (entity == null)
                throw new KeyNotFoundException("Mood entry not found");

            _db.MoodEntries.Remove(entity);
            await _db.SaveChangesAsync();
        }

        private static MoodEntryResponseDto ToDto(MoodEntry m)
            => new(m.Id, m.Score, m.Emoji, m.Notes, m.AudioUrl, m.CreatedAt);

        private static void Validate(MoodEntryCreateDto dto)
        {
            if (dto.Score < 1 || dto.Score > 10)
                throw new ArgumentException("Score must be between 1 and 10");
        }

        private static string? Clean(string? s)
        {
            if (string.IsNullOrWhiteSpace(s)) return null;
            return s.Trim();
        }
    }
}
