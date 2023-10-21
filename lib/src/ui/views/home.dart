part of com.pokedex_app.ui.views;

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late PokemonTypeEnum pokemonType = PokemonTypeEnum.ice;

  Future<void> onChangeType(PokemonTypeEnum type) async {
    pokemonType = type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PokemonType>?> pokemonTypes = ref.watch(
      pokemonTypesProvider,
    );
    AsyncValue<List<Pokemon>?> pokemonList = ref.watch(
      pokemonListProvider(pokemonType.value),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Pokédex',
          style: DisplayTextStyle.display3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 32,
        ),
        child: pokemonTypes.when(
          data: (List<PokemonType>? data) => Column(
            children: <Widget>[
              PokemonTypeBar(
                pokemonTypes: data,
                onChangeType: onChangeType,
              ),
              Spacing.spacingV32,
              pokemonList.when(
                data: (List<Pokemon>? data) => PokemonList(pokemonList: data!),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
