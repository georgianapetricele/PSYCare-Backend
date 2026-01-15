using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-L-01, TC-L-02, TC-L-03
    // Tests AuthService.LoginAsync method:
    // - AuthService 
    // - PSYCareDbContext (simulated with InMemoryDatabase)
    // - Patient and Psychologist entities
    // Verifies correct role is returned or null for invalid credentials.
    public class LoginTest
    {
        private PSYCareDbContext _context;
        private AuthService _authService;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Patients.RemoveRange(_context.Patients);
            _context.Psychologists.RemoveRange(_context.Psychologists);
            _context.SaveChanges();

            _context.Patients.Add(new Patient { Id = 1, Email = "patient@test.com", Password = "1234", Name = "name", PhoneNumber = "Phone" });
            _context.Psychologists.Add(new Psychologist { Id = 1, Email = "psy@test.com", Password = "abcd", Name = "name"});
            _context.SaveChanges();

            _authService = new AuthService(_context);
        }

        [TearDown]
        public void TearDown()
        {
            _context.Dispose();
        }

        [Test]
        public async Task LoginAsync_WithPatientCredentials_ReturnsPatientRole()
        {
            // Act
            var result = await _authService.LoginAsync("patient@test.com", "1234");

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("patient", result.GetType().GetProperty("role")?.GetValue(result));
        }

        [Test]
        public async Task LoginAsync_WithPsychologistCredentials_ReturnsPsychologistRole()
        {
            // Act
            var result = await _authService.LoginAsync("psy@test.com", "abcd");

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("psychologist", result.GetType().GetProperty("role")?.GetValue(result));
        }

        [Test]
        public async Task LoginAsync_WithInvalidCredentials_ReturnsNull()
        {
            // Act
            var result = await _authService.LoginAsync("invalid@test.com", "wrong");

            // Assert
            Assert.IsNull(result);
        }
    }
}
