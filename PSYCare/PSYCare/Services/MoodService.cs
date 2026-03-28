using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services.Interfaces;

namespace PSYCare.Services;

public class MoodService(PSYCareDbContext db) : IMoodService
{
    public async Task<MoodEntryResponseDto> CreateAsync(int patientId, MoodEntryCreateDto dto)
    {
        Validate(dto);

        if (!await db.Patients.AnyAsync(p => p.Id == patientId))
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

        db.MoodEntries.Add(entity);
        await db.SaveChangesAsync();

        return ToDto(entity);
    }

    public async Task<IReadOnlyList<MoodEntryResponseDto>> ListAsync(int patientId, int limit = 50) =>
        await db.MoodEntries
            .Where(m => m.PatientId == patientId)
            .OrderByDescending(m => m.CreatedAt)
            .Take(Math.Clamp(limit, 1, 200))
            .Select(m => new MoodEntryResponseDto(m.Id, m.Score, m.Emoji, m.Notes, m.AudioUrl, m.CreatedAt))
            .ToListAsync();

    public async Task UpdateAsync(int patientId, int moodId, MoodEntryCreateDto dto)
    {
        Validate(dto);

        var entity = await db.MoodEntries
            .FirstOrDefaultAsync(m => m.Id == moodId && m.PatientId == patientId);

        if (entity is null)
            throw new KeyNotFoundException("Mood entry not found");

        entity.Score = dto.Score;
        entity.Emoji = Clean(dto.Emoji);
        entity.Notes = Clean(dto.Notes);
        entity.AudioUrl = Clean(dto.AudioUrl);

        await db.SaveChangesAsync();
    }

    public async Task DeleteAsync(int patientId, int moodId)
    {
        var entity = await db.MoodEntries
            .FirstOrDefaultAsync(m => m.Id == moodId && m.PatientId == patientId);

        if (entity is null)
            throw new KeyNotFoundException("Mood entry not found");

        db.MoodEntries.Remove(entity);
        await db.SaveChangesAsync();
    }

    private static MoodEntryResponseDto ToDto(MoodEntry m)
        => new(m.Id, m.Score, m.Emoji, m.Notes, m.AudioUrl, m.CreatedAt);

    private static void Validate(MoodEntryCreateDto dto)
    {
        if (dto.Score is < 1 or > 10)
            throw new ArgumentException("Score must be between 1 and 10");
    }

    private static string? Clean(string? s) => string.IsNullOrWhiteSpace(s) ? null : s.Trim();
}