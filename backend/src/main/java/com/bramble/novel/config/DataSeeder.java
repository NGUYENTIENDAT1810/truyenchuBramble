package com.bramble.novel.config;

import com.bramble.novel.entity.*;
import com.bramble.novel.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final UserPreferencesRepository preferencesRepository;
    private final AuthorRepository authorRepository;
    private final GenreRepository genreRepository;
    private final BookRepository bookRepository;
    private final ChapterRepository chapterRepository;
    private final LibraryRepository libraryRepository;
    private final ReadingProgressRepository progressRepository;
    private final ReadingHistoryRepository historyRepository;
    private final CommentRepository commentRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        if (userRepository.count() > 0) {
            log.info("Database already contains data. Skipping DataSeeder.");
            return;
        }

        log.info("Seeding initial Bramble platform data...");

        // 1. Users
        User admin = User.builder()
                .email("admin@bramble.com")
                .passwordHash(passwordEncoder.encode("admin123"))
                .displayName("Bramble Admin")
                .avatarUrl("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150")
                .role(Role.ADMIN)
                .coins(9999)
                .isVip(true)
                .build();
        admin = userRepository.save(admin);

        UserPreferences adminPrefs = UserPreferences.builder()
                .user(admin)
                .theme("NIGHT")
                .fontSize(18)
                .fontFamily("Serif")
                .lineHeight(1.6)
                .marginHorizontal(24.0)
                .autoUnlock(true)
                .soundEffects(true)
                .build();
        preferencesRepository.save(adminPrefs);

        User demoUser = User.builder()
                .email("noor@example.com")
                .passwordHash(passwordEncoder.encode("password123"))
                .displayName("Noor Al-Mansoor")
                .avatarUrl("https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150")
                .role(Role.USER)
                .coins(350)
                .isVip(false)
                .build();
        demoUser = userRepository.save(demoUser);

        UserPreferences userPrefs = UserPreferences.builder()
                .user(demoUser)
                .theme("CREAM")
                .fontSize(18)
                .fontFamily("Serif")
                .lineHeight(1.6)
                .marginHorizontal(24.0)
                .autoUnlock(false)
                .soundEffects(true)
                .build();
        preferencesRepository.save(userPrefs);

        // 2. Authors
        Author author1 = Author.builder()
                .name("Clara Oswald")
                .bio("Best-selling dark fantasy and high intrigue novelist. Winner of the Astral Literary Ribbon 2024.")
                .avatarUrl("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150")
                .followersCount(14200L)
                .build();
        author1 = authorRepository.save(author1);

        Author author2 = Author.builder()
                .name("Arthur Pendelton")
                .bio("Sci-Fi architect exploring cybernetic revolutions, temporal rifts, and existential cosmos.")
                .avatarUrl("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150")
                .followersCount(9800L)
                .build();
        author2 = authorRepository.save(author2);

        Author author3 = Author.builder()
                .name("Evelyn Vance")
                .bio("Poetic romanticist crafting emotional journeys across timeless historical eras and pastoral lands.")
                .avatarUrl("https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150")
                .followersCount(21500L)
                .build();
        author3 = authorRepository.save(author3);

        Author author4 = Author.builder()
                .name("M. K. Sterling")
                .bio("Mystery thriller master of locked-room enigmas and atmospheric noir investigations.")
                .avatarUrl("https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150")
                .followersCount(8300L)
                .build();
        author4 = authorRepository.save(author4);

        Author author5 = Author.builder()
                .name("Silvia Thorne")
                .bio("Cultivation fantasy enthusiast blending eastern mythos with western character dynamics.")
                .avatarUrl("https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150")
                .followersCount(17600L)
                .build();
        author5 = authorRepository.save(author5);

        // 3. Genres
        Genre fantasy = Genre.builder().name("Fantasy").slug("fantasy").description("Epic magic, mystical realms and legendary heroes").iconName("auto_awesome").build();
        Genre scifi = Genre.builder().name("Sci-Fi").slug("sci-fi").description("Future technology, artificial intelligence and space odyssey").iconName("rocket_launch").build();
        Genre romance = Genre.builder().name("Romance").slug("romance").description("Heartwarming connections, drama, and timeless devotion").iconName("favorite").build();
        Genre mystery = Genre.builder().name("Mystery").slug("mystery").description("Suspenseful twists, detectives, and covert secrets").iconName("visibility").build();
        Genre xianxia = Genre.builder().name("Cultivation").slug("cultivation").description("Daoist arts, heavenly tribulations, and martial ascendance").iconName("sports_martial_arts").build();
        Genre adventure = Genre.builder().name("Adventure").slug("adventure").description("Expeditions across uncharted lands and perilous ruins").iconName("explore").build();

        fantasy = genreRepository.save(fantasy);
        scifi = genreRepository.save(scifi);
        romance = genreRepository.save(romance);
        mystery = genreRepository.save(mystery);
        xianxia = genreRepository.save(xianxia);
        adventure = genreRepository.save(adventure);

        // 4. Books
        Book book1 = Book.builder()
                .title("The Starlit Citadel")
                .slug("the-starlit-citadel")
                .author(author1)
                .coverUrl("https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500")
                .description("In a city suspended between colliding galaxies, an exiled scholar discovers a forgotten stargate that holds the key to preventing the celestial collapse.")
                .status(BookStatus.ONGOING)
                .rating(4.9)
                .ratingsCount(1240L)
                .viewsCount(58200L)
                .totalChapters(6L)
                .isFeatured(true)
                .isTrending(true)
                .isNewRelease(false)
                .genres(Set.of(fantasy, adventure))
                .build();
        book1 = bookRepository.save(book1);

        Book book2 = Book.builder()
                .title("Whispers of the Jade Empire")
                .slug("whispers-of-the-jade-empire")
                .author(author5)
                .coverUrl("https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=500")
                .description("An orphaned herbalist inadvertently uncovers an ancient Dragon core, setting off an imperial war across the Nine Heavens.")
                .status(BookStatus.ONGOING)
                .rating(4.8)
                .ratingsCount(980L)
                .viewsCount(44100L)
                .totalChapters(5L)
                .isFeatured(true)
                .isTrending(true)
                .isNewRelease(false)
                .genres(Set.of(xianxia, fantasy))
                .build();
        book2 = bookRepository.save(book2);

        Book book3 = Book.builder()
                .title("The Silent Chrono")
                .slug("the-silent-chrono")
                .author(author2)
                .coverUrl("https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500")
                .description("When time suddenly fractures into non-linear loops, chronomancer Liam must locate the Prime Anchor before reality dissolves.")
                .status(BookStatus.ONGOING)
                .rating(4.7)
                .ratingsCount(730L)
                .viewsCount(32000L)
                .totalChapters(4L)
                .isFeatured(false)
                .isTrending(true)
                .isNewRelease(true)
                .genres(Set.of(scifi, mystery))
                .build();
        book3 = bookRepository.save(book3);

        Book book4 = Book.builder()
                .title("Song of the Silver Meadow")
                .slug("song-of-the-silver-meadow")
                .author(author3)
                .coverUrl("https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=500")
                .description("A poetic romance about second chances in an emerald valley shrouded in morning mist and forgotten promises.")
                .status(BookStatus.COMPLETED)
                .rating(4.9)
                .ratingsCount(1650L)
                .viewsCount(67800L)
                .totalChapters(5L)
                .isFeatured(true)
                .isTrending(false)
                .isNewRelease(false)
                .genres(Set.of(romance))
                .build();
        book4 = bookRepository.save(book4);

        Book book5 = Book.builder()
                .title("The Midnight Archive")
                .slug("the-midnight-archive")
                .author(author4)
                .coverUrl("https://images.unsplash.com/photo-1507842229452-7729221237e1?w=500")
                .description("Inside London's underground labyrinth of forbidden grimoires, a rogue detective investigates murders committed by living ink.")
                .status(BookStatus.ONGOING)
                .rating(4.6)
                .ratingsCount(512L)
                .viewsCount(21900L)
                .totalChapters(4L)
                .isFeatured(false)
                .isTrending(false)
                .isNewRelease(true)
                .genres(Set.of(mystery, fantasy))
                .build();
        book5 = bookRepository.save(book5);

        Book book6 = Book.builder()
                .title("The Clockwork Alchemist")
                .slug("the-clockwork-alchemist")
                .author(author2)
                .coverUrl("https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500")
                .description("In a Victorian metropolis powered by steam and aether, a brilliant outcast discovers how to transmute mechanical souls.")
                .status(BookStatus.ONGOING)
                .rating(4.7)
                .ratingsCount(430L)
                .viewsCount(18500L)
                .totalChapters(3L)
                .isFeatured(false)
                .isTrending(true)
                .isNewRelease(true)
                .genres(Set.of(scifi, adventure))
                .build();
        book6 = bookRepository.save(book6);

        // 5. Chapters for Book 1 (The Starlit Citadel)
        String ch1Content =
                "The towers of the Citadel did not rise from the soil; they hung like crystalline stalactites from the roof of the celestial dome.\n\n" +
                "Kaelen adjusted the brass strap of his eyepiece, letting the amber glyphs pulse against his retina. Below him, eighty thousand leagues of astral fog churned in violet whorls.\n\n" +
                "\"You shouldn't be up here, Master Kaelen,\" whispered a voice behind him. It was Lyra, her cloak shimmering with silver dust from the upper archives.\n\n" +
                "\"The council declared the outer bridge forbidden after the tremor at twilight.\"\n\n" +
                "\"The council fears what they cannot measure with their sun dials,\" Kaelen answered without turning. \"Look at the resonance lines along the seventh arch. That is not seismic settling. That is an echo.\"\n\n" +
                "Lyra stepped carefully over the obsidian flagstones. When she placed her fingertips against the stone, a gentle chime reverberated deep in her bones.\n\n" +
                "\"The gate is waking,\" she murmured, her amber eyes widening in disbelief. \"After seven centuries... the Old Way is opening.\"";

        String ch2Content =
                "The grand library of the Citadel spanned seven subterranean rings, lit only by bottled starfire suspended from arched vaulting.\n\n" +
                "Kaelen unrolled the cartography parchment. The paper crackled with ancient static, illuminating coordinate runes that hadn't been charted since the Great Migration.\n\n" +
                "\"If we align the lunar focal lenses,\" Kaelen explained, tracing the spiral vector with his stylus, \"we bypass the Imperial wards entirely.\"\n\n" +
                "Lyra shook her head solemnly. \"And if the Inquisitors catch us? Treason against the Luminari isn't punished by exile. They cleanse the soul.\"\n\n" +
                "\"Then we make sure they never catch us.\"";

        String ch3Content =
                "Midnight arrived without the chime of bells. The Citadel was silent except for the hum of the core dynamo.\n\n" +
                "Kaelen slipped through the labyrinthine maintenance tunnels beneath Sector 4. The air here was dense with ozone and the scent of cold metal.\n\n" +
                "Ahead, the archway glowed with an eerie cerulean luminescence. He could feel the gravity shifting beneath his boots—each step felt as light as falling snow.\n\n" +
                "He took out the crystalline key given to him by the elder before her passing. As the key slotted into the aperture, the void spoke back.";

        Chapter c1 = Chapter.builder().book(book1).chapterNumber(1).title("Chapter 1: The Hanging spires").content(ch1Content).wordCount(180).isFree(true).coinCost(0).status(ChapterStatus.PUBLISHED).commentsCount(3L).build();
        Chapter c2 = Chapter.builder().book(book1).chapterNumber(2).title("Chapter 2: The Starfire Cartography").content(ch2Content).wordCount(140).isFree(true).coinCost(0).status(ChapterStatus.PUBLISHED).commentsCount(1L).build();
        Chapter c3 = Chapter.builder().book(book1).chapterNumber(3).title("Chapter 3: The Cerulean Portal").content(ch3Content).wordCount(150).isFree(false).coinCost(15).status(ChapterStatus.PUBLISHED).commentsCount(0L).build();
        c1 = chapterRepository.save(c1);
        c2 = chapterRepository.save(c2);
        c3 = chapterRepository.save(c3);

        // 6. Comments on Chapter 1
        Comment comm1 = Comment.builder()
                .chapter(c1)
                .user(admin)
                .content("The world building in the first paragraph is breathtaking! Loving the crystalline stalactite imagery.")
                .paragraphIndex(0)
                .likesCount(12L)
                .build();
        commentRepository.save(comm1);

        Comment comm2 = Comment.builder()
                .chapter(c1)
                .user(demoUser)
                .content("Lyra's cloak shimmering with silver dust is such a neat detail. Can't wait to see where the stargate leads!")
                .paragraphIndex(2)
                .likesCount(5L)
                .build();
        commentRepository.save(comm2);

        // 7. Library & Reading Progress for Demo User
        Library lib1 = Library.builder()
                .user(demoUser)
                .book(book1)
                .status(LibraryStatus.CURRENT)
                .lastReadAt(Instant.now().minusSeconds(1800))
                .build();
        libraryRepository.save(lib1);

        Library lib2 = Library.builder()
                .user(demoUser)
                .book(book4)
                .status(LibraryStatus.SAVED)
                .build();
        libraryRepository.save(lib2);

        ReadingProgress prog1 = ReadingProgress.builder()
                .user(demoUser)
                .book(book1)
                .chapter(c1)
                .progressPercent(42)
                .scrollOffset(320.0)
                .readingTimeSeconds(1850)
                .lastReadAt(Instant.now().minusSeconds(1800))
                .build();
        progressRepository.save(prog1);

        ReadingHistory hist1 = ReadingHistory.builder()
                .user(demoUser)
                .book(book1)
                .chapter(c1)
                .progressPercent(42)
                .scrollOffset(320.0)
                .readingTimeSeconds(1850)
                .build();
        historyRepository.save(hist1);

        log.info("Data seeding completed successfully! Seeded books, chapters, users, authors, genres, and comments.");
    }
}
