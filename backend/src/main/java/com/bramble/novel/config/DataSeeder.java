package com.bramble.novel.config;

import com.bramble.novel.entity.*;
import com.bramble.novel.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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
        if (bookRepository.count() > 0) {
            log.info("Database already contains data. Skipping DataSeeder.");
            return;
        }

        log.info("Seeding authentic Bramble platform data from design prototype...");

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
                .displayName("Noor Rahim")
                .avatarUrl("https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150")
                .role(Role.USER)
                .coins(120)
                .isVip(false)
                .build();
        demoUser = userRepository.save(demoUser);

        UserPreferences userPrefs = UserPreferences.builder()
                .user(demoUser)
                .theme("CREAM")
                .fontSize(19)
                .fontFamily("Serif")
                .lineHeight(1.75)
                .marginHorizontal(24.0)
                .autoUnlock(false)
                .soundEffects(true)
                .build();
        preferencesRepository.save(userPrefs);

        User userOleander = userRepository.save(User.builder()
                .email("oleander@bramble.com")
                .passwordHash(passwordEncoder.encode("password123"))
                .displayName("oleander")
                .role(Role.USER)
                .coins(50)
                .build());

        User userHarbourlight = userRepository.save(User.builder()
                .email("harbourlight@bramble.com")
                .passwordHash(passwordEncoder.encode("password123"))
                .displayName("harbourlight")
                .role(Role.USER)
                .coins(200)
                .build());

        User userMreads = userRepository.save(User.builder()
                .email("m_reads@bramble.com")
                .passwordHash(passwordEncoder.encode("password123"))
                .displayName("m_reads")
                .role(Role.USER)
                .coins(80)
                .build());

        User userTidepool = userRepository.save(User.builder()
                .email("tidepool@bramble.com")
                .passwordHash(passwordEncoder.encode("password123"))
                .displayName("tidepool")
                .role(Role.USER)
                .coins(300)
                .build());

        // 2. Authors
        Author wenIto = authorRepository.save(Author.builder()
                .name("Wen Ito")
                .bio("Writes slow fantasy about coastlines, debt and inherited work. Posts a chapter every Wednesday and answers notes on Sundays.")
                .avatarUrl("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150")
                .followersCount(14200L)
                .build());

        Author okonkwo = authorRepository.save(Author.builder()
                .name("R. Okonkwo")
                .bio("Court intrigue novelist with too many locked doors. Publishes on Fridays.")
                .avatarUrl("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150")
                .followersCount(9800L)
                .build());

        Author miraHalden = authorRepository.save(Author.builder()
                .name("Mira Halden")
                .bio("Literary fiction author focusing on quiet coastal homes, families, and long-standing mysteries.")
                .avatarUrl("https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150")
                .followersCount(11500L)
                .build());

        Author junPark = authorRepository.save(Author.builder()
                .name("Jun Park")
                .bio("Progression fantasy worldbuilder exploring contracts, subterranean mines, and ancient covenants.")
                .avatarUrl("https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150")
                .followersCount(16300L)
                .build());

        Author elsaVondel = authorRepository.save(Author.builder()
                .name("Elsa Vondel")
                .bio("Repairs the machines that measure grief, and refuses to explain how she calibrates them.")
                .avatarUrl("https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150")
                .followersCount(8700L)
                .build());

        Author anaFerreira = authorRepository.save(Author.builder()
                .name("Ana Ferreira")
                .bio("Epistolary fiction about lighthouses, coastlines, and forty years of letters.")
                .avatarUrl("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150")
                .followersCount(12400L)
                .build());

        // 3. Genres
        Genre slowFantasy = genreRepository.save(Genre.builder().name("Slow fantasy").slug("slow-fantasy").description("Atmospheric worldbuilding and quiet reflection").iconName("auto_awesome").build());
        Genre courtIntrigue = genreRepository.save(Genre.builder().name("Court intrigue").slug("court-intrigue").description("Political schemes, hidden motives and secrets").iconName("visibility").build());
        Genre literary = genreRepository.save(Genre.builder().name("Literary").slug("literary").description("Character-driven, profound prose and thematic depth").iconName("menu_book").build());
        Genre progression = genreRepository.save(Genre.builder().name("Progression").slug("progression").description("Growth, magic contracts, and power development").iconName("trending_up").build());
        Genre slipstream = genreRepository.save(Genre.builder().name("Slipstream").slug("slipstream").description("Surreal, speculative fiction blending reality").iconName("grain").build());
        Genre epistolary = genreRepository.save(Genre.builder().name("Epistolary").slug("epistolary").description("Stories told through letters, journals and records").iconName("mail").build());

        // 4. Books (The 6 authentic Bramble prototype novels)
        Book saltAlmanac = bookRepository.save(Book.builder()
                .title("The Salt Almanac")
                .slug("the-salt-almanac")
                .author(wenIto)
                .coverUrl("https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500")
                .description("A harbour clerk inherits her mother’s tide ledger and finds every entry after 1911 written in a hand that is not her mother’s. Twelve years of debt, weather and quiet correction, kept in a book that refuses to end.")
                .status(BookStatus.ONGOING)
                .rating(4.7)
                .ratingsCount(14200L)
                .viewsCount(84200L)
                .totalChapters(132L)
                .isFeatured(true)
                .isTrending(true)
                .isNewRelease(false)
                .genres(Set.of(slowFantasy))
                .build());

        Book nineLanterns = bookRepository.save(Book.builder()
                .title("Nine Lanterns")
                .slug("nine-lanterns")
                .author(okonkwo)
                .coverUrl("https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=500")
                .description("Nine lanterns are lit each winter. This year one goes out early, and the household must decide what it saw.")
                .status(BookStatus.ONGOING)
                .rating(4.5)
                .ratingsCount(9800L)
                .viewsCount(52100L)
                .totalChapters(88L)
                .isFeatured(true)
                .isTrending(false)
                .isNewRelease(false)
                .genres(Set.of(courtIntrigue))
                .build());

        Book houseSmallWeather = bookRepository.save(Book.builder()
                .title("A House of Small Weather")
                .slug("a-house-of-small-weather")
                .author(miraHalden)
                .coverUrl("https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500")
                .description("Four siblings, one coastal house, and a barometer that has been wrong for thirty years.")
                .status(BookStatus.COMPLETED)
                .rating(4.8)
                .ratingsCount(11500L)
                .viewsCount(67800L)
                .totalChapters(61L)
                .isFeatured(false)
                .isTrending(false)
                .isNewRelease(true)
                .genres(Set.of(literary))
                .build());

        Book copperSeason = bookRepository.save(Book.builder()
                .title("Copper Season")
                .slug("copper-season")
                .author(junPark)
                .coverUrl("https://images.unsplash.com/photo-1519681393784-d120267933ba?w=500")
                .description("The mines reopen, and with them an older contract nobody meant to honour.")
                .status(BookStatus.ONGOING)
                .rating(4.4)
                .ratingsCount(16300L)
                .viewsCount(91400L)
                .totalChapters(204L)
                .isFeatured(false)
                .isTrending(true)
                .isNewRelease(false)
                .genres(Set.of(progression))
                .build());

        Book quietMachinist = bookRepository.save(Book.builder()
                .title("The Quiet Machinist")
                .slug("the-quiet-machinist")
                .author(elsaVondel)
                .coverUrl("https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500")
                .description("She repairs the machines that measure grief, and refuses to explain how she calibrates them.")
                .status(BookStatus.ONGOING)
                .rating(4.6)
                .ratingsCount(8700L)
                .viewsCount(43200L)
                .totalChapters(47L)
                .isFeatured(false)
                .isTrending(false)
                .isNewRelease(false)
                .genres(Set.of(slipstream))
                .build());

        Book lettersToTide = bookRepository.save(Book.builder()
                .title("Letters to the Tide")
                .slug("letters-to-the-tide")
                .author(anaFerreira)
                .coverUrl("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500")
                .description("Two lighthouse keepers, forty years of letters, one delivery that never arrived.")
                .status(BookStatus.ONGOING)
                .rating(4.3)
                .ratingsCount(12400L)
                .viewsCount(38900L)
                .totalChapters(39L)
                .isFeatured(false)
                .isTrending(false)
                .isNewRelease(false)
                .genres(Set.of(epistolary))
                .build());

        // 5. Authentic Chapters for The Salt Almanac
        Chapter ch1 = chapterRepository.save(Chapter.builder()
                .book(saltAlmanac)
                .chapterNumber(1)
                .title("The Orrery")
                .content("The ledger came down from the shelf the way a tide comes in: slowly, and then all at once across her lap. Ito had not opened it since the funeral, and the salt had done its work on the binding.\n\nEvery page carried the same four columns — date, vessel, weight, correction — and her mother’s hand held steady through eleven years of them.\n\nThen, in the spring of 1911, the letters changed shape.")
                .wordCount(3400)
                .isFree(true)
                .coinCost(0)
                .commentsCount(12L)
                .build());

        Chapter ch46 = chapterRepository.save(Chapter.builder()
                .book(saltAlmanac)
                .chapterNumber(46)
                .title("The Second Hand")
                .content("The harbour was quiet when the courier docked. In the second drawer under the chart table, the wax seal remained unbroken. Ito held the letter against the lantern light, tracing the thin watermark of an anchor that had never belonged to the fleet.")
                .wordCount(3900)
                .isFree(true)
                .coinCost(0)
                .commentsCount(45L)
                .build());

        String authenticCh47Content = "The ledger came down from the shelf the way a tide comes in: slowly, and then all at once across her lap. Ito had not opened it since the funeral, and the salt had done its work on the binding.\n\n"
                + "Every page carried the same four columns — date, vessel, weight, correction — and her mother’s hand held steady through eleven years of them. Then, in the spring of 1911, the letters changed shape.\n\n"
                + "She read the entry twice. A brig called the Orrery, three tons of unspecified cargo, and in the correction column a single word that was not a number at all.\n\n"
                + "“You are reading it wrong,” said the harbourmaster from the doorway, though he had not seen the page and did not intend to.\n\n"
                + "Ito closed the book on her thumb. Outside, the water was doing what it always did, which was arrive, and leave, and keep no record of either.";

        Chapter ch47 = chapterRepository.save(Chapter.builder()
                .book(saltAlmanac)
                .chapterNumber(47)
                .title("The Ledger of Tides")
                .content(authenticCh47Content)
                .wordCount(4200)
                .isFree(true)
                .coinCost(0)
                .commentsCount(218L)
                .build());

        Chapter ch48 = chapterRepository.save(Chapter.builder()
                .book(saltAlmanac)
                .chapterNumber(48)
                .title("The Harbour Ledger")
                .content("Dawn broke over the breakwater in pale bands of grey and amber. The Orrery was already casting off when Ito reached the lower quay, its black hull low in the water under the weight of whatever had been hauled aboard before first light.")
                .wordCount(4100)
                .isFree(false)
                .coinCost(30)
                .commentsCount(0L)
                .build());

        // Chapters for other books
        Chapter nineLanternsCh1 = chapterRepository.save(Chapter.builder()
                .book(nineLanterns)
                .chapterNumber(1)
                .title("The First Light")
                .content("Nine lanterns are lit each winter along the imperial gallery. The ninth flickered and died before the snow began.")
                .wordCount(3500)
                .isFree(true)
                .coinCost(0)
                .build());

        Chapter houseCh1 = chapterRepository.save(Chapter.builder()
                .book(houseSmallWeather)
                .chapterNumber(1)
                .title("The Barometer")
                .content("The barometer on the parlour wall had read storm through four weddings and two funerals, none of which had seen a drop of rain.")
                .wordCount(3200)
                .isFree(true)
                .coinCost(0)
                .build());

        Chapter copperCh1 = chapterRepository.save(Chapter.builder()
                .book(copperSeason)
                .chapterNumber(1)
                .title("The Sealed Shaft")
                .content("When the deep bell rang from the three-hundred-fathom level, nobody working the upper seams moved towards the cages.")
                .wordCount(3800)
                .isFree(true)
                .coinCost(0)
                .build());

        // 6. Comments for Chapter 47 (The Salt Almanac)
        commentRepository.save(Comment.builder()
                .chapter(ch47)
                .user(userOleander)
                .paragraphIndex(1)
                .content("Third reread and I only just noticed she never says whose hand it is. Wen is not going to tell us until ch. 60, is he.")
                .likesCount(84L)
                .build());

        commentRepository.save(Comment.builder()
                .chapter(ch47)
                .user(userHarbourlight)
                .paragraphIndex(3)
                .content("The harbourmaster speaking without looking at the page is the whole book in one line.")
                .likesCount(51L)
                .build());

        commentRepository.save(Comment.builder()
                .chapter(ch47)
                .user(userMreads)
                .paragraphIndex(4)
                .content("Slower chapter but the last paragraph earns it. Water keeping no record — after 47 chapters of ledgers.")
                .likesCount(33L)
                .build());

        commentRepository.save(Comment.builder()
                .chapter(ch47)
                .user(userTidepool)
                .paragraphIndex(2)
                .content("Called it in ch. 12. The Orrery is not a ship.")
                .likesCount(190L)
                .build());

        // 7. Library & Active Reading for Noor
        libraryRepository.save(Library.builder()
                .user(demoUser)
                .book(saltAlmanac)
                .status(LibraryStatus.CURRENT)
                .build());

        libraryRepository.save(Library.builder()
                .user(demoUser)
                .book(nineLanterns)
                .status(LibraryStatus.CURRENT)
                .build());

        libraryRepository.save(Library.builder()
                .user(demoUser)
                .book(houseSmallWeather)
                .status(LibraryStatus.SAVED)
                .build());

        libraryRepository.save(Library.builder()
                .user(demoUser)
                .book(copperSeason)
                .status(LibraryStatus.CURRENT)
                .build());

        libraryRepository.save(Library.builder()
                .user(demoUser)
                .book(quietMachinist)
                .status(LibraryStatus.SAVED)
                .build());

        progressRepository.save(ReadingProgress.builder()
                .user(demoUser)
                .book(saltAlmanac)
                .chapter(ch47)
                .scrollOffset(0.62)
                .progressPercent(62)
                .build());

        progressRepository.save(ReadingProgress.builder()
                .user(demoUser)
                .book(nineLanterns)
                .chapter(nineLanternsCh1)
                .scrollOffset(0.18)
                .progressPercent(18)
                .build());

        progressRepository.save(ReadingProgress.builder()
                .user(demoUser)
                .book(copperSeason)
                .chapter(copperCh1)
                .scrollOffset(0.07)
                .progressPercent(7)
                .build());

        historyRepository.save(ReadingHistory.builder()
                .user(demoUser)
                .book(saltAlmanac)
                .chapter(ch47)
                .progressPercent(62)
                .readingTimeSeconds(900)
                .build());

        log.info("Data seeding completed successfully with authentic Bramble novel dataset!");
    }
}
