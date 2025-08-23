# Database Schema

This document outlines the proposed database schema for the ship noise analysis project.

## Tables

### `ships`

Stores information about each ship.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `mmsi` | `INTEGER` | The ship's MMSI number. |
| `name` | `TEXT` | The name of the ship. |

### `hydrophones`

Stores information about each hydrophone.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `latitude` | `REAL` | The latitude of the hydrophone. |
| `longitude` | `REAL` | The longitude of the hydrophone. |
| `depth` | `REAL` | The depth of the hydrophone. |
| `calibration_data` | `TEXT` | The calibration data for the hydrophone (e.g., in JSON format). |

### `cpas`

Stores the CPA data.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `ship_id` | `INTEGER` | Foreign key to the `ships` table. |
| `timestamp` | `TIMESTAMP` | The timestamp of the CPA. |
| `range` | `REAL` | The range at the CPA. |
| `...` | `...` | Other relevant CPA parameters. |

### `acoustic_data`

Stores the raw acoustic data from the hydrophones.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `hydrophone_id` | `INTEGER` | Foreign key to the `hydrophones` table. |
| `timestamp` | `TIMESTAMP` | The timestamp of the data. |
| `data` | `BLOB` | The raw acoustic data. |

### `ais_data`

Stores the AIS data for each ship.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `ship_id` | `INTEGER` | Foreign key to the `ships` table. |
| `timestamp` | `TIMESTAMP` | The timestamp of the data. |
| `latitude` | `REAL` | The latitude of the ship. |
| `longitude` | `REAL` | The longitude of the ship. |
| `cog` | `REAL` | The course over ground of the ship. |
| `sog` | `REAL` | The speed over ground of the ship. |

### `source_levels`

Stores the calculated source level for each ship at each time step.

| Column | Data Type | Description |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key. |
| `ship_id` | `INTEGER` | Foreign key to the `ships` table. |
| `timestamp` | `TIMESTAMP` | The timestamp of the data. |
| `aspect_angle` | `REAL` | The aspect angle of the ship. |
| `source_level` | `REAL` | The calculated source level. |
