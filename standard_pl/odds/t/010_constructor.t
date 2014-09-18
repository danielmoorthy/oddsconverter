use Test::More (tests => 22);
use Test::Exception;

use_ok('OddsConverter');

new_ok('OddsConverter' => [probability => 0.5]);
new_ok('OddsConverter' => [probability => 0]);
new_ok('OddsConverter' => [probability => 1]);
new_ok('OddsConverter' => [probability => 5e-2]);
new_ok('OddsConverter' => [decimal_odds => 3]);
new_ok('OddsConverter' => [decimal_odds => 10.32]);
new_ok('OddsConverter' => [decimal_odds => 5.12232]);
new_ok('OddsConverter' => [decimal_odds => 1]);
new_ok('OddsConverter' => [roi => 30]);
new_ok('OddsConverter' => [roi => 25.52]);
new_ok('OddsConverter' => [roi => 79.8412]);
new_ok('OddsConverter' => [roi => 0]);

dies_ok { OddConverter->new } 'No empty constructors';
dies_ok { OddsConverter->new(probability => -1) } 'probability: No negative probabilities';
dies_ok { OddsConverter->new(probability => 1.1) } 'probability: No probabilities > 1';
dies_ok { OddsConverter->new(probability => 'one') } 'probability: No non-numeric probabilities';
dies_ok { OddsConverter->new(decimal_odds => -3) } 'decimal_odds: No negative decimal odds';
dies_ok { OddsConverter->new(decimal_odds => 0.5) } 'decimal_odds: No decimal odds should be < 1';
dies_ok { OddsConverter->new(decimal_odds => 'eight thousand') } 'decimal_odds: No non-numeric decimal odds';
dies_ok { OddsConverter->new(roi => -50.30) } 'roi: No negative rois';
dies_ok { OddsConverter->new(roi => '30 percent') } 'roi: No non-numeric rois';
