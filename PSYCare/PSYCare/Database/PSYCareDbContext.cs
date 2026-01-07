using Microsoft.EntityFrameworkCore;
using PSYCare.Database.Entities;

namespace PSYCare.Database;

public class PSYCareDbContext : DbContext
{
    public PSYCareDbContext(DbContextOptions<PSYCareDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(
            typeof(PSYCareDbContext).Assembly
        );
    }
}
