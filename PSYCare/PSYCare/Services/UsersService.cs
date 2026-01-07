using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbUser = PSYCare.Database.Entities.User;

namespace PSYCare.Services;

public class UsersService : IUsersService
{
    private readonly PSYCareDbContext _context;

    public UsersService(PSYCareDbContext context)
    {
        _context = context;
    }
    public async Task<User?> GetUserByIdAsync(int userId)
    {
        var dbUser = await _context.Users.FindAsync(userId);

        if(dbUser == null)
        {
            return null;
        }

        return new User
        {
            Email = dbUser.Email,
            Name = dbUser.Name
        };
    }

    public async Task CreateUserAsync(User user)
    {
        var dbUser = new DbUser
        {
            Email = user.Email,
            Name = user.Name
        };

        _context.Users.Add(dbUser);
        await _context.SaveChangesAsync();
    }
}
