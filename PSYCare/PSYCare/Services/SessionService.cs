using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services.Interfaces;

namespace PSYCare.Services
{
    public class SessionService : ISessionService
    {
        private readonly PSYCareDbContext _context;

        public SessionService(PSYCareDbContext context)
        {
            _context = context;
        }

        public async Task<SessionResponseDto> CreateAsync(SessionCreateDto dto)
        {
            await EnsurePatientExists(dto.PatientId);
            await EnsurePsychologistExists(dto.PsychologistId);

            var session = new Session
            {
                PatientId = dto.PatientId,
                PsychologistId = dto.PsychologistId,
                ScheduledAt = dto.ScheduledAt,
                Notes = dto.Notes,
                Status = dto.Status
            };

            _context.Sessions.Add(session);
            await _context.SaveChangesAsync();

            return MapToDto(session);
        }

        public async Task<IReadOnlyList<SessionResponseDto>> GetByPatientIdAsync(int patientId)
        {
            var sessions = await _context.Sessions
                .Where(s => s.PatientId == patientId)
                .OrderByDescending(s => s.ScheduledAt)
                .ToListAsync();

            return sessions.Select(s => MapToDto(s)).ToList();
        }

        public async Task<IReadOnlyList<SessionResponseDto>> GetByPsychologistIdAsync(int psychologistId)
        {
            var sessions = await _context.Sessions
                .Where(s => s.PsychologistId == psychologistId)
                .OrderBy(s => s.ScheduledAt)
                .ToListAsync();

            return sessions.Select(s => MapToDto(s)).ToList();
        }

        public async Task<SessionResponseDto> GetByIdAsync(int sessionId)
        {
            var session = await GetSessionOrThrow(sessionId);
            return MapToDto(session);
        }

        public async Task ConfirmSessionAsync(int sessionId)
        {
            var session = await GetSessionOrThrow(sessionId);
            session.Status = "confirmed";

            await _context.SaveChangesAsync();
        }

        public async Task CancelSessionAsync(int sessionId)
        {
            var session = await GetSessionOrThrow(sessionId);
            session.Status = "cancelled";

            await _context.SaveChangesAsync();
        }

        // ------------------ Guards ------------------

        private async Task EnsurePatientExists(int patientId)
        {
            if (!await _context.Patients.AnyAsync(p => p.Id == patientId))
                throw new KeyNotFoundException($"Patient with ID {patientId} not found");
        }

        private async Task EnsurePsychologistExists(int psychologistId)
        {
            if (!await _context.Psychologists.AnyAsync(p => p.Id == psychologistId))
                throw new KeyNotFoundException($"Psychologist with ID {psychologistId} not found");
        }

        private async Task<Session> GetSessionOrThrow(int sessionId)
        {
            var session = await _context.Sessions.FindAsync(sessionId);
            return session ?? throw new KeyNotFoundException($"Session with ID {sessionId} not found");
        }

        // ------------------ Mapping ------------------

        private static SessionResponseDto MapToDto(Session session) =>
            new()
            {
                Id = session.Id,
                PatientId = session.PatientId,
                PsychologistId = session.PsychologistId,
                ScheduledAt = session.ScheduledAt,
                Status = session.Status,
                Notes = session.Notes
            };
    }
}