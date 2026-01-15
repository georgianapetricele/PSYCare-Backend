using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-M-01, TC-M-02, TC-M-03, TC-M-04, TC-M-05, TC-M-06
    // - MoodService methods: CreateAsync, ListAsync, UpdateAsync, DeleteAsync
    // - PSYCareDbContext  for Patients and MoodEntries
    // - Validates behavior: creation, listing, updating, deletion, Score validation
    internal class MoodTests
    {
        private PSYCareDbContext _context;
        private MoodService _service;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: "MoodTestDb")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Patients.RemoveRange(_context.Patients);
            _context.MoodEntries.RemoveRange(_context.MoodEntries);
            _context.SaveChanges();

            // Add a test patient
            _context.Patients.Add(new DbPatient { Id = 1, Email = "test@test.com", Name = "Test Patient", Password = "1234", PhoneNumber = "nb" });
            _context.SaveChanges();

            _service = new MoodService(_context);
        }

        [TearDown]
        public void TearDown() => _context.Dispose();

        [Test]
        public async Task CreateAsync_ShouldCreateMoodEntry()
        {
            var dto = new MoodEntryCreateDto(7,"😊", "Feeling good",null);

            var result = await _service.CreateAsync(1, dto);

            Assert.IsNotNull(result);
            Assert.AreEqual(dto.Score, result.Score);
            Assert.AreEqual(dto.Emoji, result.Emoji);
            Assert.AreEqual(dto.Notes, result.Notes);
        }

        [Test]
        public void CreateAsync_InvalidScore_ThrowsArgumentException()
        {
            var dto = new MoodEntryCreateDto(11, "😊", "Feeling good", null);

            Assert.ThrowsAsync<ArgumentException>(async () =>
            {
                await _service.CreateAsync(1, dto);
            });
        }


        [Test]
        public async Task ListAsync_ShouldReturnEntriesInDescendingOrder()
        {
            _context.MoodEntries.AddRange(
                new MoodEntry { Id = 1, PatientId = 1, Score = 5, CreatedAt = DateTimeOffset.UtcNow.AddHours(-1) },
                new MoodEntry { Id = 2, PatientId = 1, Score = 7, CreatedAt = DateTimeOffset.UtcNow }
            );
            _context.SaveChanges();

            var result = await _service.ListAsync(1);

            Assert.AreEqual(2, result.Count);
            Assert.AreEqual(7, result[0].Score);
            Assert.AreEqual(5, result[1].Score);
        }

        [Test]
        public async Task UpdateAsync_ShouldUpdateMoodEntry()
        {
            _context.MoodEntries.Add(new MoodEntry { Id = 1, PatientId = 1, Score = 5, Emoji = "😐", Notes = "Old", CreatedAt = DateTimeOffset.UtcNow });
            _context.SaveChanges();

            var dto = new MoodEntryCreateDto(9, "😊", "Feeling good", "url");
            await _service.UpdateAsync(1, 1, dto);

            var updated = await _context.MoodEntries.FindAsync(1);
            Assert.AreEqual(9, updated.Score);
            Assert.AreEqual("😊", updated.Emoji);
            Assert.AreEqual("Feeling good", updated.Notes);
            Assert.AreEqual("url", updated.AudioUrl);
        }

        [Test]
        public async Task DeleteAsync_ShouldRemoveMoodEntry()
        {
            _context.MoodEntries.Add(new MoodEntry { Id = 1, PatientId = 1, Score = 5, CreatedAt = DateTimeOffset.UtcNow });
            _context.SaveChanges();

            await _service.DeleteAsync(1, 1);

            var deleted = await _context.MoodEntries.FindAsync(1);
            Assert.IsNull(deleted);
        }

        [Test]
        public void DeleteAsync_NonExistingEntry_ThrowsKeyNotFoundException()
        {
            Assert.ThrowsAsync<KeyNotFoundException>(async () =>
            {
                await _service.DeleteAsync(1, 999);
            });
        }
    }
}
