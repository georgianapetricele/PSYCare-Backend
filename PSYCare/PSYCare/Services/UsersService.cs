using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPacient = PSYCare.Database.Entities.Pacient;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;

namespace PSYCare.Services;

public class UsersService : IUsersService
{
    private readonly PSYCareDbContext _context;

    public UsersService(PSYCareDbContext context)
    {
        _context = context;
    }
    public async Task<Pacient?> GetPacientByIdAsync(int userId)
    {
        var dbUser = await _context.Pacients.FindAsync(userId);

        if(dbUser == null)
        {
            return null;
        }

        return new Pacient
        {
            Email = dbUser.Email,
            Name = dbUser.Name,
            PhoneNumber = dbUser.PhoneNumber,
            Faculty = dbUser.Faculty,
            Location = dbUser.Location,
            Problem = dbUser.Problem,
            Age = dbUser.Age
        };
    }
    public async Task<Psychologist?> GetPsychologistByIdAsync(int userId)
    {
        var dbUser = await _context.Psychologists.FindAsync(userId);

        if (dbUser == null)
        {
            return null;
        }

        return new Psychologist
        {
            Email = dbUser.Email,
            Name = dbUser.Name,
            Location = dbUser.Location,
        };
    }

    public async Task<Pacient> CreatePacientAsync(Pacient user)
    {
        var dbUser = new DbPacient
        {
            Email = user.Email,
            Name = user.Name,
            PhoneNumber = user.PhoneNumber,
            Faculty = user.Faculty,
            Location = user.Location,
            Problem = user.Problem,
            Age = user.Age,
            Password = user.Password
        };

        _context.Pacients.Add(dbUser);
        await _context.SaveChangesAsync();

        // map DB -> Service model
        return new Pacient
        {
            Id = dbUser.Id, // ID generat de PostgreSQL
            Email = dbUser.Email,
            Name = dbUser.Name,
            PhoneNumber = dbUser.PhoneNumber,
            Faculty = dbUser.Faculty,
            Location = dbUser.Location,
            Problem = dbUser.Problem,
            Age = dbUser.Age
        };
    }


    public async Task<Psychologist> CreatePsychologistAsync(Psychologist user)
    {
        var dbUser = new DbPsychologist
        {
            Email = user.Email,
            Name = user.Name,
            Location = user.Location,
            Password = user.Password
        };

        _context.Psychologists.Add(dbUser);
        await _context.SaveChangesAsync();

        // map DB → Service model
        return new Psychologist
        {
            Id = dbUser.Id, // ID generat de DB
            Email = dbUser.Email,
            Name = dbUser.Name,
            Location = dbUser.Location
        };
    }

    public async Task<object?> LoginAsync(string email, string password)
    {
        var pacient = await _context.Pacients
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (pacient != null)
            return new { role = "pacient", data = pacient };

        var psychologist = await _context.Psychologists
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (psychologist != null)
            return new { role = "psychologist", data = psychologist };

        return null;
    }


}
