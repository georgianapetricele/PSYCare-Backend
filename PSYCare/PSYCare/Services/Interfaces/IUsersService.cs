using PSYCare.Services.Models;

namespace PSYCare.Services.Interfaces;

public interface IUsersService
{
    Task<User?> GetUserByIdAsync(int userId);
    Task CreateUserAsync(User user);
}
