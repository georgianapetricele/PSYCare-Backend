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
            // Validate patient and psychologist exist
            var patientExists = await _context.Patients.AnyAsync(p => p.Id == dto.PatientId);
            var psychologistExists = await _context.Psychologists.AnyAsync(p => p.Id == dto.PsychologistId);

            if (!patientExists)
                throw new KeyNotFoundException($"Patient with ID {dto.PatientId} not found");

            if (!psychologistExists)
                throw new KeyNotFoundException($"Psychologist with ID {dto.PsychologistId} not found");

            var session = new Session
            {
                PatientId = dto.PatientId,
                PsychologistId = dto.PsychologistId,
                ScheduledAt = dto.ScheduledAt,
                Notes = dto.Notes,
                Status = dto.Status,
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

            return sessions.Select(MapToDto).ToList();
        }

        public async Task<IReadOnlyList<SessionResponseDto>> GetByPsychologistIdAsync(int psychologistId)
        {
            var sessions = await _context.Sessions
                .Where(s => s.PsychologistId == psychologistId)
                .OrderBy(s => s.ScheduledAt)
                .ToListAsync();

            return sessions.Select(MapToDto).ToList();
        }

        public async Task<SessionResponseDto> GetByIdAsync(int sessionId)
        {
            var session = await _context.Sessions.FindAsync(sessionId);
            if (session == null)
                throw new KeyNotFoundException($"Session with ID {sessionId} not found");

            return MapToDto(session);
        }

        public async Task ConfirmSessionAsync(int sessionId)
        {
            var session = await _context.Sessions.FindAsync(sessionId);
            if (session == null)
                throw new KeyNotFoundException($"Session with ID {sessionId} not found");

            session.Status = "confirmed";

            await _context.SaveChangesAsync();
        }

        public async Task CancelSessionAsync(int sessionId)
        {
            var session = await _context.Sessions.FindAsync(sessionId);
            if (session == null)
                throw new KeyNotFoundException($"Session with ID {sessionId} not found");

            session.Status = "cancelled";

            await _context.SaveChangesAsync();
        }

        private static SessionResponseDto MapToDto(Session session)
        {
            return new SessionResponseDto
            {
                Id = session.Id,
                PatientId = session.PatientId,
                PsychologistId = session.PsychologistId,
                ScheduledAt = session.ScheduledAt,
                Status = session.Status,
                Notes = session.Notes,
            };
        }
    }
}