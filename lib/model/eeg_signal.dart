class EegSignal{
  final double x;
  final double y;

  const EegSignal({required this.x,required this.y});

  factory EegSignal.fromList(List<double> value){
    return EegSignal(x: value[0], y: value[1]);
  }
}