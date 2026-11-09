<?php
	/*
	| VER ASISTENCIAS: la grilla del mes, un alumno por fila y un día por
	| columna. Traída de Sendero de Campeones v1 (asistenciaList).
	|
	| Las sedes se acotan en el servidor con la regla de la sesión
	| (asistenciaController::consultarAsistenciaMensual -> condicionSede).
	| Exportar (Excel / imprimir) exige permiso_exportar en el menú: la
	| información de menores sale del sistema solo si alguien lo decidió.
	*/
	use app\controllers\asistenciaController;
	use app\controllers\reporteController;

	$insAsistencia = new asistenciaController();
	$insReporte    = new reporteController();

	$h = static fn($v) => htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');

	/* ---------- Filtros: por defecto, el mes en curso de todas las sedes visibles ---------- */
	$anio = (int)($_POST['asistencia_anio'] ?? date('Y'));
	$mes  = (int)($_POST['asistencia_mes'] ?? date('n'));
	if ($anio < 2000 || $anio > 2100) { $anio = (int)date('Y'); }
	if ($mes < 1 || $mes > 12)        { $mes  = (int)date('n'); }
	$sedeid    = max(0, (int)($_POST['alumno_sedeid'] ?? 0));
	$horarioid = max(0, (int)($_POST['horario_id'] ?? 0));

	$opcionesSede = $insReporte->opcionesSedeAsistencia($sedeid);
	$ofrecerTodas = $insAsistencia->ofrecerTodasLasSedes();
	/* Con una sola sede y sin «Todas», el combo la trae elegida: la consulta
	   tiene que usar esa misma, no la 0. */
	if (!$ofrecerTodas && $sedeid === 0 && preg_match('/value="(\d+)"/', $opcionesSede, $primeraSede)) {
		$sedeid = (int)$primeraSede[1];
	}

	$MESES  = [1 => 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
	$INICIAL_DIA = [1 => 'L', 'M', 'X', 'J', 'V', 'S', 'D'];
	$MARCAS = asistenciaController::MARCAS_ASISTENCIA;

	$diasMes  = (int)date('t', mktime(0, 0, 0, $mes, 1, $anio));
	$hoy      = ($anio === (int)date('Y') && $mes === (int)date('n')) ? (int)date('j') : 0;
	$periodo  = $MESES[$mes] . ' ' . $anio;

	$anios        = $insAsistencia->aniosConAsistencia();
	$sinEntreno   = $insAsistencia->diasSinEntrenamiento($anio, $mes);
	$consulta     = $insAsistencia->consultarAsistenciaMensual($anio, $mes, $sedeid, $horarioid);
	$filas        = $consulta['filas'];
	$resumen      = $consulta['resumen'];
	$verSede      = $sedeid === 0;
	$exportar     = puede_exportar('asistenciaList');

	$colorPct = static function ($p): string {
		if ($p === null) { return 'secondary'; }
		return $p >= 90 ? 'success' : ($p >= 75 ? 'warning' : 'danger');
	};
	$pct = static fn($p) => $p === null ? '—' : rtrim(rtrim(number_format((float)$p, 1, ',', ''), '0'), ',') . ' %';

	/* Primera columna de días en la tabla: Alumno, [Sede], Edad. */
	$primerDia = $verSede ? 3 : 2;

	$tituloVista = 'Ver asistencias';
	$extras      = ['datatables'];
	$cabeceraExtra = <<<'CSS'
	<style>
		/* 31 días no caben: la tabla se desplaza en horizontal y el alumno queda fijo. */
		.ds-asis-grilla { font-size: .8rem; white-space: nowrap; margin-bottom: 0; }
		.ds-asis-grilla > :not(caption) > * > .ds-asis-dia { width: 1.75rem; min-width: 1.75rem; padding: .15rem !important; text-align: center; }
		.ds-asis-grilla .ds-asis-alumno { position: sticky; left: 0; z-index: 2; min-width: 15rem; background-color: var(--bs-body-bg); border-right: 2px solid var(--bs-border-color); }
		.ds-asis-grilla thead th { background-color: var(--bs-tertiary-bg); vertical-align: middle; }
		.ds-asis-grilla thead .ds-asis-alumno { z-index: 3; background-color: var(--bs-tertiary-bg); }
		.ds-asis-grilla .ds-asis-libre { background-image: repeating-linear-gradient(45deg, transparent 0 3px, var(--bs-border-color-translucent) 3px 6px); color: var(--bs-secondary-color); }
		.ds-asis-grilla .ds-asis-hoy { outline: 2px solid var(--bs-primary); outline-offset: -2px; }
		.ds-asis-m { font-weight: 600; }
		.ds-asis-m-P { background-color: var(--bs-success) !important; color: #fff !important; }
		.ds-asis-m-A { background-color: var(--bs-warning) !important; color: #212529 !important; }
		.ds-asis-m-F { background-color: var(--bs-danger) !important; color: #fff !important; }
		.ds-asis-m-J { background-color: var(--bs-secondary) !important; color: #fff !important; }
		.ds-asis-leyenda { display: flex; flex-wrap: wrap; gap: .25rem .9rem; font-size: .8rem; color: var(--bs-secondary-color); }
		.ds-asis-leyenda span { display: inline-flex; align-items: center; gap: .3rem; }
		.ds-asis-leyenda i { display: inline-block; width: 1.1rem; height: 1.1rem; line-height: 1.1rem; text-align: center; border-radius: .2rem; font-style: normal; font-size: .7rem; }
		.ds-asis-barra { height: 4px; margin-top: 3px; }
		.ds-asis-resumen .info-box { height: 100%; }
		.ds-asis-detalle { display: block; font-size: .8rem; color: var(--bs-secondary-color); }
	</style>
	CSS;
	require_once "app/views/inc/cabecera.php";
?>
  <body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
    <div class="app-wrapper ds-core">
      <?php require_once "app/views/inc/navbar.php"; ?>
      <?php require_once "app/views/inc/main-sidebar.php"; ?>

      <div class="app-main">

		<div class="app-content-header">
			<div class="container-fluid">
				<div class="row mb-2 g-2 align-items-center">
					<div class="col-sm-7">
						<h4 class="m-0">Ver asistencias</h4>
					</div>
					<div class="col-sm-5">
						<ol class="breadcrumb float-sm-end mb-0">
							<li class="breadcrumb-item"><a href="<?php echo APP_URL; ?>dashboard/">Inicio</a></li>
							<li class="breadcrumb-item">Asistencia</li>
							<li class="breadcrumb-item active" aria-current="page">Ver asistencias</li>
						</ol>
					</div>
				</div>
			</div>
		</div>

		<section class="app-content">
			<div class="container-fluid ds-crud">

				<!-- =================== Criterios =================== -->
				<form action="<?php echo APP_URL; ?>asistenciaList/" method="POST" autocomplete="off" class="card" id="form-asistencia-mes">
					<div class="card-header">
						<h3 class="card-title"><i class="fas fa-filter me-2" aria-hidden="true"></i>Criterios de búsqueda</h3>
						<div class="card-tools">
							<button type="button" class="btn btn-tool" data-lte-toggle="card-collapse" title="Plegar o desplegar" aria-label="Plegar o desplegar"><i data-lte-icon="expand" class="fas fa-plus"></i><i data-lte-icon="collapse" class="fas fa-minus"></i></button>
						</div>
					</div>
					<div class="card-body">
						<div class="row g-3">
							<div class="col-12 col-sm-6 col-lg-3">
								<label for="alumno_sedeid" class="form-label">Sede</label>
								<select class="form-select" id="alumno_sedeid" name="alumno_sedeid">
									<?php if ($ofrecerTodas): ?>
										<option value="0" <?php echo $sedeid === 0 ? 'selected' : ''; ?>>Todas</option>
									<?php endif; ?>
									<?php echo $opcionesSede; ?>
								</select>
							</div>
							<div class="col-6 col-sm-3 col-lg-2">
								<label for="asistencia_anio" class="form-label">Año</label>
								<select class="form-select" id="asistencia_anio" name="asistencia_anio">
									<?php foreach ($anios as $a): ?>
										<option value="<?php echo (int)$a; ?>" <?php echo (int)$a === $anio ? 'selected' : ''; ?>><?php echo (int)$a; ?></option>
									<?php endforeach; ?>
								</select>
							</div>
							<div class="col-6 col-sm-3 col-lg-2">
								<label for="asistencia_mes" class="form-label">Mes</label>
								<select class="form-select" id="asistencia_mes" name="asistencia_mes">
									<?php foreach ($MESES as $num => $nombre): ?>
										<option value="<?php echo $num; ?>" <?php echo $num === $mes ? 'selected' : ''; ?>><?php echo $nombre; ?></option>
									<?php endforeach; ?>
								</select>
							</div>
							<div class="col-12 col-sm-8 col-lg-3">
								<label for="horario_id" class="form-label">Horario</label>
								<select class="form-select" id="horario_id" name="horario_id">
									<option value="0" <?php echo $horarioid === 0 ? 'selected' : ''; ?>>Todos</option>
									<?php echo $insAsistencia->opcionesHorarioMensual($horarioid, $sedeid); ?>
								</select>
							</div>
							<div class="col-12 col-sm-4 col-lg-2 d-flex align-items-end">
								<div class="w-100"><?php echo ds_boton_buscar(); ?></div>
							</div>
						</div>
					</div>
				</form>

				<!-- =================== Resumen del mes =================== -->
				<div class="row g-2 g-md-3 ds-asis-resumen mt-0" aria-label="Resumen de <?php echo $h($periodo); ?>">
					<?php foreach ([
						['Alumnos con registro', (string)$resumen['alumnos'], $periodo, 'text-bg-primary', 'fa-users'],
						['Asistencia general', $pct($resumen['porcentaje']), $resumen['asistidos'] . ' asistidos de ' . $resumen['dias'] . ' días', 'text-bg-' . $colorPct($resumen['porcentaje']), 'fa-chart-pie'],
						['Faltas', (string)$resumen['F'], $resumen['A'] . ' atraso(s) · ' . $resumen['J'] . ' justificada(s)', $resumen['F'] > 0 ? 'text-bg-danger' : 'text-bg-success', 'fa-user-xmark'],
						['Bajo 75 %', (string)$resumen['riesgo'], 'alumnos a dar seguimiento', $resumen['riesgo'] > 0 ? 'text-bg-warning' : 'text-bg-secondary', 'fa-triangle-exclamation'],
					] as [$texto, $valor, $detalle, $clase, $icono]): ?>
						<div class="col-6 col-lg-3">
							<div class="info-box mb-0">
								<span class="info-box-icon <?php echo $clase; ?> shadow-sm"><i class="fas <?php echo $icono; ?>" aria-hidden="true"></i></span>
								<div class="info-box-content">
									<span class="info-box-text"><?php echo $h($texto); ?></span>
									<span class="info-box-number"><?php echo $h($valor); ?></span>
									<span class="ds-asis-detalle"><?php echo $h($detalle); ?></span>
								</div>
							</div>
						</div>
					<?php endforeach; ?>
				</div>

				<!-- =================== Grilla =================== -->
				<div class="card ds-crud__lista mt-3" id="asistencia-mes">
					<div class="card-header d-flex flex-wrap align-items-center gap-2">
						<h3 class="card-title me-auto">
							<i class="fas fa-calendar-check me-2" aria-hidden="true"></i>Asistencia de <?php echo $h($periodo); ?>
							<span class="badge text-bg-secondary ms-1"><?php echo count($filas); ?></span>
						</h3>
						<div class="ds-asis-leyenda" aria-label="Leyenda">
							<?php foreach ($MARCAS as $letra => $nombre): ?>
								<span><i class="ds-asis-m ds-asis-m-<?php echo $letra; ?>"><?php echo $letra; ?></i><?php echo $nombre; ?></span>
							<?php endforeach; ?>
							<span><i class="ds-asis-libre border"></i>Fin de semana</span>
						</div>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table id="tabla-asistencia" class="table table-bordered table-striped table-sm align-middle ds-asis-grilla" style="width:100%">
								<thead>
									<tr>
										<th class="ds-asis-alumno" rowspan="2">Alumno</th>
										<?php if ($verSede): ?><th rowspan="2">Sede</th><?php endif; ?>
										<th rowspan="2" class="text-center">Edad</th>
										<?php for ($d = 1; $d <= $diasMes; $d++): ?>
											<th class="ds-asis-dia<?php echo isset($sinEntreno[$d]) ? ' ds-asis-libre' : ''; ?><?php echo $d === $hoy ? ' ds-asis-hoy' : ''; ?>"
												title="<?php echo $h(($sinEntreno[$d] ?? '') . ($d === $hoy ? ' (hoy)' : '')); ?>"><?php echo $d; ?></th>
										<?php endfor; ?>
										<?php foreach ($MARCAS as $letra => $nombre): ?>
											<th rowspan="2" class="text-center" title="<?php echo $nombre; ?>"><?php echo $letra; ?></th>
										<?php endforeach; ?>
										<th rowspan="2" class="text-center" style="min-width: 6rem;">% Asistencia</th>
									</tr>
									<tr>
										<?php for ($d = 1; $d <= $diasMes; $d++): ?>
											<th class="ds-asis-dia<?php echo isset($sinEntreno[$d]) ? ' ds-asis-libre' : ''; ?>"><?php echo $INICIAL_DIA[(int)date('N', mktime(0, 0, 0, $mes, $d, $anio))]; ?></th>
										<?php endfor; ?>
									</tr>
								</thead>
								<tbody>
									<?php foreach ($filas as $fila): $c = $colorPct($fila['porcentaje']); ?>
									<tr>
										<td class="ds-asis-alumno" data-order="<?php echo $h($fila['nombre']); ?>">
											<a href="<?php echo APP_URL; ?>buscarAsistencia/<?php echo (int)$fila['alumno_id']; ?>/" class="link-body-emphasis text-decoration-none" title="Ver el calendario de asistencia"><?php echo $h($fila['nombre']); ?></a>
											<?php if (!$fila['activo']): ?><span class="badge text-bg-secondary ms-1">Inactivo</span><?php endif; ?>
										</td>
										<?php if ($verSede): ?><td><?php echo $h($fila['sede']); ?></td><?php endif; ?>
										<td class="text-center"><?php echo $fila['edad'] === null ? '' : (int)$fila['edad']; ?></td>
										<?php for ($d = 1; $d <= $diasMes; $d++):
											$marca = $fila['marcas'][$d];
											$clases = 'ds-asis-dia' . ($marca !== '' ? ' ds-asis-m ds-asis-m-' . $marca : (isset($sinEntreno[$d]) ? ' ds-asis-libre' : '')) . ($d === $hoy ? ' ds-asis-hoy' : '');
										?>
											<td class="<?php echo $clases; ?>"<?php echo $marca !== '' ? ' title="' . $h($MARCAS[$marca]) . '"' : ''; ?>><?php echo $marca; ?></td>
										<?php endfor; ?>
										<?php foreach ($MARCAS as $letra => $nombre): ?>
											<td class="text-center<?php echo $letra === 'F' && $fila['conteo']['F'] > 0 ? ' text-danger fw-semibold' : ''; ?>"><?php echo (int)$fila['conteo'][$letra]; ?></td>
										<?php endforeach; ?>
										<td class="text-center" data-order="<?php echo $fila['porcentaje'] ?? -1; ?>">
											<?php if ($fila['porcentaje'] === null): ?>
												<span class="text-body-secondary">—</span>
											<?php else: ?>
												<strong class="text-<?php echo $c; ?>-emphasis"><?php echo $h($pct($fila['porcentaje'])); ?></strong>
												<div class="progress ds-asis-barra" role="presentation"><div class="progress-bar bg-<?php echo $c; ?>" style="width: <?php echo (float)$fila['porcentaje']; ?>%"></div></div>
											<?php endif; ?>
										</td>
									</tr>
									<?php endforeach; ?>
								</tbody>
							</table>
						</div>
						<p class="small text-body-secondary mb-0 mt-2">
							<i class="fas fa-circle-info me-1" aria-hidden="true"></i>Porcentaje de asistencia: presentes y atrasos sobre los días registrados de cada alumno en el mes (el justificado cuenta como día, pero no suma). Es la misma regla de «Ver registro».
						</p>
					</div>
				</div>

			</div>
		</section>

      </div>

      <?php require_once "app/views/inc/footer.php"; ?>
    </div>

	<script src="<?php echo APP_URL; ?>app/views/dist/plugins/jquery/jquery.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/overlayscrollbars/js/overlayscrollbars.browser.es6.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/bootstrap5/js/bootstrap.bundle.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/dataTables.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/dataTables.bootstrap5.min.js"></script>
	<?php if ($exportar): ?>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/dataTables.buttons.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/buttons.bootstrap5.min.js"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/buttons.html5.min.js"></script>
	<?php /* jszip se trae al pulsar Excel, no en cada carga (exportar.js). */ ?>
	<script src="<?php echo ds_recurso('ds_core/assets/js/exportar.js'); ?>"></script>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/datatables2/js/buttons.print.min.js"></script>
	<?php endif; ?>
	<script src="<?php echo DS_HUB_URL; ?>ds_core/assets/vendor/adminlte4/js/adminlte.min.js"></script>

	<script>
	document.addEventListener('DOMContentLoaded', function () {
		var form = document.getElementById('form-asistencia-mes');

		/* Cambiar de sede recarga sus horarios. */
		document.getElementById('alumno_sedeid').addEventListener('change', function () {
			document.getElementById('horario_id').value = '0';
			form.submit();
		});

		var PRIMER_DIA = <?php echo $primerDia; ?>, DIAS = <?php echo $diasMes; ?>;
		var columnasDia = Array.from({ length: DIAS }, function (_, i) { return i + PRIMER_DIA; });

		var opciones = {
			autoWidth: false,
			paging: true,
			pageLength: 50,
			order: [[0, 'asc']],
			columnDefs: [
				{ targets: columnasDia, orderable: false, searchable: false },
				{ targets: -1, type: 'num' }
			],
			layout: {
				topStart: <?php echo $exportar ? "'buttons'" : 'null'; ?>,
				topEnd: 'search',
				bottomStart: 'info',
				bottomEnd: { paging: { firstLast: false } }
			},
			language: {
				emptyTable: <?php echo json_encode('No hay asistencias registradas en ' . $periodo . ' con estos criterios'); ?>,
				info: '_START_ a _END_ de _TOTAL_ alumnos',
				infoEmpty: 'Sin alumnos',
				infoFiltered: '(de _MAX_)',
				search: '',
				searchPlaceholder: 'Filtrar por alumno…',
				zeroRecords: 'Ningún alumno coincide con el filtro',
				paginate: { next: 'Siguiente', previous: 'Anterior' }
			}
		};

		<?php if ($exportar): ?>
		var sede = document.getElementById('alumno_sedeid');
		var horario = document.getElementById('horario_id');
		var titulo = <?php echo json_encode('Asistencias ' . $periodo); ?>
			+ ' | Sede: ' + sede.options[sede.selectedIndex].text.trim()
			+ ' | Horario: ' + (horario.value !== '0' ? horario.options[horario.selectedIndex].text.split('|')[0].trim() : 'Todos');
		var todas = { modifier: { page: 'all', search: 'applied', order: 'applied' } };
		opciones.buttons = [
			{ extend: 'excel', text: '<i class="fas fa-file-excel me-1"></i>Excel', title: titulo, exportOptions: todas },
			{ extend: 'print', text: '<i class="fas fa-print me-1"></i>Imprimir', title: titulo, exportOptions: todas }
		];
		<?php endif; ?>

		new DataTable('#tabla-asistencia', opciones);
	});
	</script>

	<script src="<?php echo ds_recurso('ds_futbol/app/views/dist/js/ajax.js'); ?>" ></script>
	<script src="<?php echo ds_recurso('ds_futbol/app/views/dist/js/main.js'); ?>" ></script>
	<script src="<?php echo APP_URL; ?>app/views/dist/js/sweetalert2.all.min.js" ></script>
  </body>
</html>
