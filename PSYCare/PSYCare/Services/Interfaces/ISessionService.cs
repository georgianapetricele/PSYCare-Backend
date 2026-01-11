using PSYCare.Controllers.Models;

namespace PSYCare.Services.Interfaces
{
    public interface ISessionService
    {
        Task<SessionResponseDto> CreateAsync(SessionCreateDto dto);
        Task<IReadOnlyList<SessionResponseDto>> GetByPatientIdAsync(int patientId);
        Task<IReadOnlyList<SessionResponseDto>> GetByPsychologistIdAsync(int psychologistId);
        Task<SessionResponseDto> GetByIdAsync(int sessionId);
        Task ConfirmSessionAsync(int sessionId);
        Task CancelSessionAsync(int sessionId);
    }
}