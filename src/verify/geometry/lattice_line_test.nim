# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random, sets
import cplib/math/int128
import cplib/geometry/lattice_line

static:
    doAssert not compiles(initLatticeLine(1.0, 2.0, 0.0))

type RawLine = tuple[x, y, dx, dy: int]
proc onLine(l: RawLine, x, y: int): bool =
    l.dx * (y-l.y) == l.dy * (x-l.x)
proc build(l: RawLine): LatticeLine =
    initLatticeLine(l.x, l.y, l.dx, l.dy)
proc verifyPair(a, b: RawLine) =
    let actual = intersection(build(a), build(b))
    let reversed = intersection(build(b), build(a))
    doAssert actual.kind == reversed.kind
    if onLine(b, a.x, a.y) and onLine(b, a.x+a.dx, a.y+a.dy):
        doAssert actual.kind == latticeSameLine
        doAssert actual.line == build(a)
        doAssert reversed.line == build(a)
    else:
        let g = gcd(abs(a.dx), abs(a.dy))
        var found = false
        var expected: tuple[x, y: int]
        for t in -100..100:
            let p = (x: a.x + t*(a.dx div g), y: a.y + t*(a.dy div g))
            if onLine(b, p.x, p.y):
                doAssert not found
                found = true
                expected = p
        if found:
            doAssert actual.kind == latticePoint
            doAssert actual.point.x == expected.x and actual.point.y == expected.y
            doAssert actual.point.x == reversed.point.x and actual.point.y ==
                    reversed.point.y
            doAssert build(a).contains(actual.point) and build(b).contains(actual.point)
        else:
            doAssert actual.kind == latticeNone
proc verifyCount(l: RawLine, xmin, xmax, ymin, ymax: int) =
    var expected = 0
    if xmin <= xmax and ymin <= ymax:
        for x in xmin..xmax:
            for y in ymin..ymax:
                if onLine(l, x, y): inc expected
    doAssert build(l).countLatticePoints(xmin, xmax, ymin, ymax) == expected

template rejects(body: untyped) =
    block:
        var rejected = false
        try:
            discard body
        except ValueError:
            rejected = true
        doAssert rejected

block:
    let a = initLatticeLine(2, -4, 6)
    doAssert a.di == 1 and a.dj == -2 and a.c == 3
    doAssert a == initLatticeLine(-3, 6, -9)
    doAssert a == initLatticeLine(0, 3, -10, 20)
    doAssert a == initLatticeLine((x: 0, y: 3), (x: 1, y: 1))
    doAssert a == initLatticeLine((x: 0'i32, y: 3'i32), (x: 1'i32, y: 1'i32))
    doAssert a == initLatticeLine((x: 0'i64, y: 3'i64), (x: 1'i64, y: 1'i64))
    doAssert a.contains(1, 1) and not a.contains(0, 0)
    doAssert a.contains((x: 1'i64, y: 1'i64))
    doAssert a.contains(1'i64, 1'i32)
    doAssert a == initLatticeLine(2'i64, -4'i32, 6'i16)
    doAssert a.countLatticePoints(-1'i64, 1'i32, 1'i16, 5'i8) == 3
    var lines = initHashSet[LatticeLine]()
    lines.incl a
    lines.incl initLatticeLine(-3, 6, -9)
    lines.incl initLatticeLine(1, -2, 4)
    doAssert lines.len == 2
    rejects(initLatticeLine(0, 0, 1))
    rejects(initLatticeLine(0, 0, 0, 0))
    rejects(initLatticeLine((x: 1, y: 2), (x: 1, y: 2)))
    rejects(initLatticeLine(2, 4, 1))
    rejects(initLatticeLine(0, 2, 1))
    let uninitialized = default(LatticeLine)
    rejects(uninitialized.contains(0, 0))
    rejects(uninitialized.di)
    rejects(uninitialized.dj)
    rejects(uninitialized.c)
    rejects(intersection(uninitialized, a))
    rejects(intersection(a, uninitialized))
    rejects(uninitialized.countLatticePoints(0, 0, 0, 0))
    doAssert uninitialized == default(LatticeLine)
    doAssert uninitialized != a

var small: seq[RawLine]
for x in -1..1:
    for y in -1..1:
        for tx in -1..1:
            for ty in -1..1:
                if x != tx or y != ty:
                    small.add (x, y, tx-x, ty-y)
for a in small:
    for b in small: verifyPair(a, b)
    for xmin in -2..2:
        for xmax in -2..2:
            for ymin in -2..2:
                for ymax in -2..2: verifyCount(a, xmin, xmax, ymin, ymax)

var rng = initRand(459)
proc randomLine(): RawLine =
    result = (rng.rand(-2..2), rng.rand(-2..2), rng.rand(-3..3), rng.rand(-3..3))
    if result.dx == 0 and result.dy == 0: result.dx = 1
for trial in 0..<3000:
    let a = randomLine()
    let b = randomLine()
    verifyPair(a, b)
    verifyCount(a, rng.rand(-8..8), rng.rand(-8..8), rng.rand(-8..8), rng.rand(-8..8))
    let scale = [-5, -2, 2, 7][rng.rand(3)]
    let shifted = initLatticeLine(a.x+a.dx*11, a.y+a.dy*11, a.dx*scale, a.dy*scale)
    doAssert shifted == build(a)
    doAssert hash(shifted) == hash(build(a))

block:
    let horizontal = initLatticeLine(1, 0, 0)
    let vertical = initLatticeLine(0, 1, 0)
    doAssert horizontal.countLatticePoints(-3, 3, -4, 4) == 7
    doAssert vertical.countLatticePoints(-3, 3, -4, 4) == 9
    doAssert horizontal.countLatticePoints(-3, 3, 1, 4) == 0
    doAssert vertical.countLatticePoints(1, 3, -4, 4) == 0
    doAssert intersection(horizontal, initLatticeLine(1, 0, 1)).kind == latticeNone
    doAssert intersection(initLatticeLine(1, 1, 0), initLatticeLine(1, -1,
            1)).kind == latticeNone
    doAssert initLatticeLine(3, -2, 0).countLatticePoints(-5, -1, 1, 5) == 1
    doAssert initLatticeLine(3, -2, 0).countLatticePoints(-2, -1, 1, 5) == 0
    doAssert horizontal.countLatticePoints(0, 0, 0, 0) == 1

block:
    let unsignedLine = initLatticeLine((x: 0'u64, y: high(uint64)),
        (x: high(uint64), y: high(uint64)))
    doAssert unsignedLine.contains(high(uint64), high(uint64))
    doAssert unsignedLine.countLatticePoints(0'u64, high(uint64),
        high(uint64), high(uint64)) == parseInt128("18446744073709551616")
    let lo = low(int64)
    let hi = high(int64)
    let width = parseInt128("18446744073709551616")
    let line = initLatticeLine((x: lo, y: lo), (x: hi, y: hi))
    doAssert line.di == 1 and line.dj == 1 and line.c == 0
    doAssert line.countLatticePoints(lo, hi, lo, hi) == width
    doAssert initLatticeLine(1, 0, hi).countLatticePoints(lo, hi, hi, hi) == width
    doAssert initLatticeLine(0, 1, -to_Int128(hi)).countLatticePoints(hi, hi,
            lo, hi) == width
    let cross = intersection(initLatticeLine(1, 0, lo), initLatticeLine(0, 1, lo))
    doAssert cross.kind == latticePoint and cross.point.x == -to_Int128(lo) and
            cross.point.y == to_Int128(lo)
    doAssert initLatticeLine(1, -1, 0).countLatticePoints(lo, hi, lo, hi) == width-1
    let nearA = initLatticeLine(hi, to_Int128(hi)-1, 1)
    let nearB = initLatticeLine(to_Int128(hi)-1, to_Int128(hi)-2, -1)
    let crossing = intersection(nearA, nearB)
    doAssert crossing.kind == latticePoint
    doAssert crossing.point.x == -parseInt128("18446744073709551613")
    doAssert crossing.point.y == -parseInt128("18446744073709551611")
    doAssert nearA.contains(crossing.point) and nearB.contains(crossing.point)
    let big = to_Int128(1000000000000'i64)
    let far = intersection(initLatticeLine(big, big-1, big*big),
                           initLatticeLine(big-1, big-2, -big*big))
    doAssert far.kind == latticePoint
    doAssert far.point.x == -parseInt128("1999999999999000000000000000000000000")
    doAssert far.point.y == -parseInt128("1999999999997000000000000000000000000")

block:
    let max128 = parseInt128("170141183460469231731687303715884105727")
    let min128 = parseInt128("-170141183460469231731687303715884105728")
    rejects(initLatticeLine(min128, 1, 0))
    rejects(initLatticeLine(0, min128, 0))
    rejects(initLatticeLine(-1, 0, min128))
    let minHorizontal = initLatticeLine(1, 0, min128)
    doAssert minHorizontal.contains(0, min128)
    doAssert minHorizontal.countLatticePoints(0, 0, min128, min128) == 1
    rejects(intersection(initLatticeLine(0, 1, min128), minHorizontal))
    rejects(initLatticeLine(max128, max128, 1, -1))
    rejects(initLatticeLine((x: min128, y: to_Int128(0)), (x: max128,
            y: to_Int128(0))))
    rejects(initLatticeLine(2, 1, 0).contains(0, max128))
    rejects(intersection(initLatticeLine(max128, 1, 0), initLatticeLine(1,
            max128, 0)))
    rejects(intersection(initLatticeLine(2, 1, max128), initLatticeLine(3, 1, 0)))
    rejects(initLatticeLine(1, 0, 0).countLatticePoints(min128, max128, 0, 0))
    rejects(initLatticeLine(2, 3, max128).countLatticePoints(0, 1, 0, 1))
    let maxHorizontal = initLatticeLine(1, 0, max128)
    doAssert maxHorizontal.countLatticePoints(0, 1, max128, max128) == 2

block:
    let fixtures = [
        ("727084652035", "696266742991795383371769",
                "-584025605334162473347714",
                "-930880916584955816267967888276726136",
                "-930880916583675523919641930420006653"),
        ("499228555758", "-188013554068563353273909",
                "-544129439829221943695621",
                "-177783219330962518905215897279091605",
                "-177783219330606403019455238688669893"),
        ("850174487565", "127533338645080298917101",
                "-420406600541469227055790",
                "-465844557014194472845851183707683314",
                "-465844557013646532906664634181710423"),
        ("261468346813", "-956338643065702939546634",
                "912825893059923739843611",
                "488727361181299285300708436089492551",
                "488727361179430120764582809410102306"),
        ("180131130973", "163029925092671034414162", "770326077143803875943938",
                "109392942704684562395714405369766210",
                "109392942704077266243663272528236434"),
        ("842118430879", "228193706591379103791031", "978203478565659187797157",
                "631597052319125527995490510447355785",
                "631597052318375518223516230363349659"),
        ("697018620310", "-347995473132318051845384",
                "334043414196219530239425",
                "475393804243156811681604624538025406",
                "475393804242474772794276086955940597"),
        ("510007442630", "682341287116882312113286", "779438172927939835968036",
                "49520134420516922404098149390105786",
                "49520134420419825518287091866251036"),
        ("916657477682", "-753860393838236230031814", "90371076552663755976806",
                "773871090227534587346752463679587026",
                "773871090226690355876361563693578406"),
        ("54263880088", "-619398988870687050825351",
                "-690635442400033792119224",
                "-3865566372830254947414969491926175",
                "-3865566372759018493885622750632302"),
        ("863139070590", "-606528161608599525526555",
                "628122796458965251529794",
                "1065675480448884395931429032393149355",
                "1065675480447649744973361467616093006"),
        ("791598655058", "891416905481237703012548",
                "-542298930891132788626318",
                "-1134927527806832661947131322137271680",
                "-1134927527805398946110758951645632814"),
        ("78466361406", "-968873014073828134583116", "63495258070581288251696",
                "81006181945202119380514399295482556",
                "81006181944169751108369989872647744"),
        ("637904510822", "-276055736184952328144596",
                "-703498422553044292477240",
                "-272667617752355328073309294834017964",
                "-272667617751927885386941202869685320"),
        ("302124033084", "803323190089734279323818",
                "-107914826111831710770376",
                "-275306904553477128013737750052990478",
                "-275306904552565889997536184062896284"),
        ("984322469156", "-579873248955529120593751",
                "650289148219893321660980",
                "1210876488249995905188597116721983285",
                "1210876488248765742791421694279728554"),
    ]
    for f in fixtures:
        let n = parseInt128(f[0])
        let a = initLatticeLine(n, n-1, parseInt128(f[1]))
        let b = initLatticeLine(n-1, n-2, parseInt128(f[2]))
        let answer = intersection(a, b)
        doAssert answer.kind == latticePoint
        doAssert answer.point.x == parseInt128(f[3]) and answer.point.y ==
                parseInt128(f[4])

block:
    let fixtures = [
        ("515725099057", "-794407337660", "-527562212777038008029241",
                "-9098149671601015074", "5908987933481207591",
                "-8607871671226981825", "5918270894572072898", "18285509"),
        ("531196369310", "946423948767", "-444474477238422506637079",
                "-1343708745273843463", "184866178616345813",
                "-3807686812416450338", "7237405272931991361", "2877608"),
        ("120035499393", "685396889236", "208162129959191994354111",
                "-4993351166837386322", "2300028090507456428",
                "-7491303175304319378", "7510193060890940311", "21887313"),
        ("156626027979", "-772349959039", "848853920393593155557805",
                "-7224383702904450998", "5694101145238748401",
                "-4004366363697862088", "5133973113804551816", "11831864"),
        ("985497276380", "-535419737531", "5664775983749090120845",
                "-1999954667666005252", "5238757477648198280",
                "-7708439347363429382", "652258438599712822", "6534070"),
        ("64008572893", "-246433780254", "236370012573878217805139",
                "-2123761317418048179", "7038238709533101500",
                "-6955636043592392184", "4188602515810167711", "45222041"),
        ("411947490556", "-179187487497", "74701218152500512360339",
                "-1207803346387124729", "8845134581495643223",
                "-4016311085071565564", "1176104387343527339", "24403445"),
        ("795984887593", "669158057525", "76922055752083069673786",
                "-5360953190518055668", "2610062398436232206",
                "-5899152449824035039", "3701321819443700043", "10014029"),
        ("865115736161", "-18618372964", "-648866601464412222394581",
                "-6447384998771855524", "5791722961973366601",
                "-1026319331028417540", "9110003138558709453", "14147365"),
        ("84811225670", "-1585058259", "60826863834650817419590",
                "-3790783618036651325", "7528682525903606362",
                "-4282579684932117145", "786454356025082791", "133466602"),
        ("197638397643", "-981345017044", "-603447665849659657892705",
                "-4695663171790122019", "4325070028216348060",
                "-421597574886259895", "6150997158922207668", "6697537"),
        ("308624672098", "412769334771", "-360677016953532490090059",
                "-421553788596560366", "1608818567644571112",
                "-6243526697922787202", "2837660876209421594", "6578775"),
        ("633458755732", "111956631299", "-116124203004392337471010",
                "-6838546597963988345", "3108785637755309310",
                "-5535197105170639593", "6294431635605908724", "15703204"),
        ("910305071871", "-145876208177", "-229670832656992529530201",
                "-8864795902145491396", "2275384790898304561",
                "-9060501559976912783", "8078837198915967667", "12237854"),
        ("50128084779", "-306004437910", "23144798401095748043007",
                "-1133725550676785069", "3421278998300560501",
                "-914387732626494918", "5905392816981182049", "22286542"),
        ("63219965369", "18271945196", "3518940302500784283962",
                "-2277813601441416819", "8099986626704609209",
                "-3511692607761649344", "4766923202012318944", "164153843"),
        ("308456226828", "-119224426345", "-303105960004192562829845",
                "-4806065511772104265", "6768006243785428408",
                "-8563505019837886498", "918982194393462100", "29649556"),
        ("841254977248", "824246536355", "685729467490155994706037",
                "-6394525467756432196", "2250173082859691365",
                "-1074201991491531599", "15487776946025214", "1322043"),
        ("516046981031", "-470875001876", "181169976392105030579841",
                "-467462842248467069", "1603575684952891370",
                "-4639942328802396225", "3630194417457238133", "4013276"),
        ("516149238480", "520331413987", "-466448268331132683210991",
                "-372609859272698122", "2244382419473805322",
                "-1919707410293869967", "1564513554466751862", "3728669"),
        ("295523458115", "-948813263499", "1214355791595280210014655",
                "-8777430083457388616", "568689713997264067",
                "-6606172023233578592", "4310934855230613910", "6467844"),
        ("328915170867", "95525378969", "-109069381749794077032246",
                "-3613170834502681049", "4394607318663064232",
                "-199822713077839810", "5297684064540897893", "15452739"),
        ("241250634964", "605256011343", "28049566772451590132070",
                "-4399415793545215990", "2052917247219921294",
                "-2620268259621995202", "5506832599568787927", "12838670"),
        ("17755111473", "-572284819610", "412291762288060666904289",
                "-7113881304003774905", "7673266674266290072",
                "-2883085519877688710", "2299040308197267536", "9055152"),
        ("386399517340", "241282673273", "303661191606653880600147",
                "-6773835741627135374", "4096438279459479361",
                "-6782486295024046776", "1816992174638286469", "25061203"),
        ("111281267738", "-366624657759", "-253541849303840605966748",
                "-3699226238665774587", "3494557072435342895",
                "-4497717641679679823", "7056891574473016918", "31516181"),
        ("18338290582", "-4021183355", "15268427776943335812657",
                "-1370585123001831282", "5172959438786377145",
                "-8963572220077487690", "704593518265048414", "356824129"),
        ("346786195632", "661109763415", "270998734164419558003753",
                "-958971941364919523", "6261205111865021860",
                "-7746696746994911612", "3847628021980321171", "8585264"),
        ("351333841863", "434612791213", "-140978335805407289003836",
                "-233271670165239580", "859212962534255748",
                "-1184611902324885791", "5758975305229236867", "3109535"),
        ("316026514294", "929482867581", "75012884974584969578478",
                "-1613126437550872173", "1308013308703541945",
                "-628918417192914038", "3961921136625338726", "4815568"),
        ("331911198983", "198994486108", "288289499883464995015730",
                "-8736928209821599290", "360227586169397445",
                "-892064144245627349", "1702748606502090182", "5568176"),
        ("200194192037", "9659407546", "-52715717460060297407104",
                "-6063576190380834774", "2464464167236787128",
                "-4712692776304119187", "1993198816991328278", "42598840"),
    ]
    for f in fixtures:
        let l = initLatticeLine(parseInt128(f[0]), parseInt128(f[1]),
                parseInt128(f[2]))
        doAssert l.countLatticePoints(parseInt128(f[3]), parseInt128(f[4]),
            parseInt128(f[5]), parseInt128(f[6])) == parseInt128(f[7])

echo "Hello World"
