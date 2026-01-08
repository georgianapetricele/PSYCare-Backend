using PSYCare.Controllers.Models;

namespace PSYCare.Services.Interfaces
{
    public interface IMoodService
    {
        Task<MoodEntryResponseDto> CreateAsync(int patientId, MoodEntryCreateDto dto);
        Task<IReadOnlyList<MoodEntryResponseDto>> ListAsync(int patientId, int limit = 50);
        Task UpdateAsync(int patientId, int moodId, MoodEntryCreateDto dto);
        Task DeleteAsync(int patientId, int moodId);
    }
}
