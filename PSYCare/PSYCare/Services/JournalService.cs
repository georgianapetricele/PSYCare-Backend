using PSYCare.Controllers.Models;
using PSYCare.Database.Entities;
using PSYCare.Database;
using Microsoft.EntityFrameworkCore;

namespace PSYCare.Services;

public class JournalService(PSYCareDbContext db) : IJournalService
{
    public async Task<JournalEntryResponseDto> CreateAsync(int patientId, JournalEntryCreateDto dto)
    {
        if (!await db.Patients.AnyAsync(p => p.Id == patientId))
            throw new KeyNotFoundException("Patient not found");

        var entity = new JournalEntry
        {
            PatientId = patientId,
            Text = Clean(dto.Text),
            CreatedAt = DateTimeOffset.UtcNow
        };

        db.JournalEntries.Add(entity);
        await db.SaveChangesAsync();

        return ToDto(entity);
    }

    public async Task<IReadOnlyList<JournalEntryResponseDto>> ListAsync(int patientId, int limit = 50) =>
        await db.JournalEntries
            .Where(m => m.PatientId == patientId)
            .OrderByDescending(m => m.CreatedAt)
            .Take(Math.Clamp(limit, 1, 200))
            .Select(m => new JournalEntryResponseDto(m.Id, m.Text, m.CreatedAt))
            .ToListAsync();

    public async Task UpdateAsync(int patientId, int entryId, JournalEntryCreateDto dto)
    {
        var entity = await db.JournalEntries
            .FirstOrDefaultAsync(m => m.Id == entryId && m.PatientId == patientId);

        if (entity is null)
            throw new KeyNotFoundException("Mood entry not found");

        entity.Text = Clean(dto.Text);
        await db.SaveChangesAsync();
    }

    public async Task DeleteAsync(int patientId, int entryId)
    {
        var entity = await db.JournalEntries
            .FirstOrDefaultAsync(m => m.Id == entryId && m.PatientId == patientId);

        if (entity is null)
            throw new KeyNotFoundException("Mood entry not found");

        db.JournalEntries.Remove(entity);
        await db.SaveChangesAsync();
    }

    private static JournalEntryResponseDto ToDto(JournalEntry m)
        => new(m.Id, m.Text, m.CreatedAt);

    private static string? Clean(string? s)
        => string.IsNullOrWhiteSpace(s) ? null : s.Trim();
}