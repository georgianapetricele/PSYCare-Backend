using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using PSYCare.Database.Entities;

namespace PSYCare.Database.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {

        builder.Property(x => x.Email)
               .IsRequired()
               .HasMaxLength(256);

        builder.HasIndex(x => x.Email)
               .IsUnique();

        builder.Property(x => x.Name)
                .IsRequired()
                .HasMaxLength(100);
    }
}