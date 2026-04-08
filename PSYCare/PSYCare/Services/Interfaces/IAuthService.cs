namespace PSYCare.Services.Interfaces;

public interface IAuthService
{
    Task<object?> LoginAsync(string email, string password);

    Task<object?> GetUserByIdAsync(int id);
}
