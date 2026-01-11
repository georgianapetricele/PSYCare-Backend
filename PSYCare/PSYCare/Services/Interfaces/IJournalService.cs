using PSYCare.Controllers.Models;

namespace PSYCare.Services
{
    public interface IJournalService
    {
        Task<JournalEntryResponseDto> CreateAsync(int patientId, JournalEntryCreateDto dto);
        Task<IReadOnlyList<JournalEntryResponseDto>> ListAsync(int patientId, int limit = 50);
        Task UpdateAsync(int patientId, int entryId, JournalEntryCreateDto dto);
        Task DeleteAsync(int patientId, int entryId);
    }
}
