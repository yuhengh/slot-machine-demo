package
{
    public class SlotMachine
    {
        public static const SLOT0:Array = [0, 1, 0, 2, 0];
        public static const SLOT1:Array = [0, 1, 2];
        public static const SLOT2:Array = [1, 0, 1, 2];

        public static const LINE_OFFSET:Array = [0, -1, 1];

        public static const PAY_TABLE:Array = [5, 10, 20];

        private var _slots:Array;
        private var _positions:Array;

        public function SlotMachine()
        {
            _slots = [SLOT0, SLOT1, SLOT2];
            _positions = [0, 0, 0];
        }

        public function get slots():Array
        {
            return _slots;
        }

        public function get positions():Array
        {
            return _positions;
        }

        public function spin():void
        {
            for (var i:int = 0; i < 3; ++i)
            {
                _positions[i] = randomRange(0, _slots[i].length);
            }
        }

        public function get numLine():int
        {
            return LINE_OFFSET.length;
        }

        public function getPayment(line:int):int
        {
            var payment:int;

            for (var i:int =0; i < line; ++i)
                for (var j:int = 0; j < 3; ++j)
                {
                    var offset:int = LINE_OFFSET[i];
                    if (_slots[0][(_positions[0] + offset + SLOT0.length) % SLOT0.length] == j
                            && _slots[1][(_positions[1] + offset + SLOT1.length) % SLOT1.length] == j
                            && _slots[2][(_positions[2] + offset + SLOT2.length) % SLOT2.length] == j)
                        payment += PAY_TABLE[j];
                }

            return payment;
        }

        private function shuffle(array:Array):Array
        {
            var res:Array = [];

            while (array.length)
            {
                var id:int = Math.random() * array.length;
                res.push(array.removeAt(id));
            }

            return res;
        }

        private function randomRange(min:int, max:int):int
        {
            return min + Math.floor(Math.random() * (max - min));
        }
    }
}
